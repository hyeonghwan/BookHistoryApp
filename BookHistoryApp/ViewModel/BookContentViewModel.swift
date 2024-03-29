//
//  BookContentViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import OpenGraph


protocol ContentViewModelType: AnyObject {
    
    //input
    var onTextViewData: AnyObserver<BookViewModelData> { get }
    var onParagraphData: AnyObserver<NSAttributedString> {get}
    
    func createBlockAttributeInput(_ blockType: CustomBlockType.Base,
                                   _ current: NSRange,
                                   _ diposeBag: DisposeBag)

    func removePlaceHolderAttribute(_ attributes: [NSAttributedString.Key : Any],
                                    _ range: Int)
    
    func replaceBlockAttribute(_ text: String,
                               _ paragraphRange: NSRange,
                               _ blockType: CustomBlockType.Base) -> Bool
    
    //input to store blockData on COreData button tap
    func storeBlockValues(_ tap: Signal<Void>)
    //input to store blockData on COreData view dissapear
    func storeBlockValues()
    
    
    // input
    func bindingBlocksToParagraphUtil(_ blocks: [BlockObject])
    
    
    //OUtPut
    var toTextObservable: Observable<BookViewModelData> { get }
    
    var toParagraphBlockTypeEventResult: Observable<CustomBlockType.Base>? { get }
    
}

protocol ContentVMBooMarkAble: AnyObject{
    
    var isPasteValue: Bool { get }
    
    //input
    var onPasteValue: AnyObserver<Bool> { get }
    var onURLData: AnyObserver<URL> { get }
    
    //output
//    var toPasteContent:
    var toMetaDataURL: Observable<MetaDataDictionatyOnURL> { get }
}

protocol ParagraphTrackingDependency: AnyObject{
    var paragraphTrackingUtility: ParagraphTrackingUtility {get set}
}

typealias ContentViewModelProtocol = ContentViewModelType & ContentVMBooMarkAble & ParagraphTrackingDependency


struct TextViewData{
    let id: UUID?
    let title: String?
    let attributedString: NSAttributedString?
}

struct BookViewModelData {
    let id: UUID?
    let bookTitle: String?
    let bookContent: NSAttributedString?
    let bookPage: String?
    
    init(){
        self.id = nil
        self.bookTitle = nil
        self.bookContent = nil
        self.bookPage = nil
    }
    
    init(id: UUID?, bookTitle: String?, bookContent: NSAttributedString?, bookPage: String?) {
        self.id = id
        self.bookTitle = bookTitle
        self.bookContent = bookContent
        self.bookPage = bookPage
    }
}

class BookContentViewModel: NSObject, ContentViewModelProtocol{
    
    
    struct Dependencies{
        let service: BookServiceAble
        let paragrphTrackingUtility: ParagraphTrackingUtility
        
        
    }
    
    var service: BookServiceAble?
    
    var paragraphTrackingUtility: ParagraphTrackingUtility
    
    
    //MARK: ContentViewModelType
    //input
    var onParagraphData: AnyObserver<NSAttributedString>
    
    var onTextViewData: AnyObserver<BookViewModelData>
    
    
    //outPUT Block EventType
    var toParagraphBlockTypeEventResult: Observable<CustomBlockType.Base>?
    
    //outPUT
    var toTextObservable: Observable<BookViewModelData>
    
    
    var toBlockObservable: Observable<[BlockObject?]>?
    
    //MARK: ContentVMBooMarkAble
    var isPasteValue: Bool = false
    
    //input
    var onURLData: AnyObserver<URL>
    var onPasteValue: AnyObserver<Bool>
    
    //output
    var toMetaDataURL: Observable<MetaDataDictionatyOnURL>
    
    
    var disposeBag = DisposeBag()
    
    
    deinit{
        print("contentModel deinit")
    }
    
    init(dependencies: Dependencies) {
        self.service = dependencies.service
        self.paragraphTrackingUtility = ParagraphTrackingUtility()
//        self.paragraphTrackingUtility = dependencies.paragrphTrackingUtility
        
        
        
        //ContentViewModelType
        let paragraphPipe = PublishSubject<NSAttributedString>()
        let textViewDataPipe = PublishSubject<BookViewModelData>()
        let observablePipe = BehaviorSubject<BookViewModelData>(value: BookViewModelData())
        
        onParagraphData = paragraphPipe.asObserver()
        
        onTextViewData = textViewDataPipe.asObserver()
        
        toTextObservable = observablePipe
        
        
        //ContentVMBooMarkAble
        let urlPipe = PublishSubject<URL>()
        let metaDataPipe = PublishSubject<MetaDataDictionatyOnURL>()
        let pastePipe = PublishSubject<Bool>()
        let pasteOutPutPipe = PublishSubject<Bool>()
        
        onPasteValue = pastePipe.asObserver()
        onURLData = urlPipe.asObserver()
        toMetaDataURL = metaDataPipe
        
        
        super.init()
        
        guard let service = service else {return}
        
        paragraphPipe
            .observe(on: MainScheduler.instance)
            .withLatestFrom(observablePipe){[weak self] textViewAttributedString, original in
                guard let self = self else {return TextViewData(id: nil, title: nil, attributedString: nil)}
                guard original.id != nil else { return TextViewData(id: nil,
                                                                    title: self.paragraphTrackingUtility.paragraphs.first!,
                                                                        attributedString: textViewAttributedString) }
                return TextViewData(id: original.id,
                                    title: self.paragraphTrackingUtility.paragraphs.first!
                                    ,attributedString: textViewAttributedString)
            }
            .flatMap(service.rxAddParagraphData(_:))
            .subscribe(onNext: { result in
                switch result{
                case .success(_):
                    print("add success")
                case .failure(let error):
                    print("error occur: \(error)")
                }
            })
            .disposed(by: disposeBag)
  
        
        textViewDataPipe
            .subscribe(onNext: observablePipe.onNext(_:))
            .disposed(by: disposeBag)
        
        
        urlPipe
            .flatMap(service.makeBookMark(_:))
            .subscribe(onNext: metaDataPipe.onNext(_:))
            .disposed(by: disposeBag)
      
        
        pastePipe
            .bind(onNext: { [weak self] value in
                guard let self = self else {return}
                self.isPasteValue = value
            })
            .disposed(by: disposeBag)
    }
    
}

//MARK: - extension VM func to binding
extension BookContentViewModel{
  
    func bindingBlocksToParagraphUtil(_ blocks: [BlockObject]){
        self.paragraphTrackingUtility.rx.blockObjects.onNext(blocks)
    }
    
    func storeBlockValues() {
        self.paragraphTrackingUtility
            .getBlockObjectObservable()
            .flatMap(self.service!.rxAddBlockObjectDatas(_:))
            .subscribe(onNext: { flag in
                print("success : \(flag)")
            }).disposed(by: disposeBag)
    }
    func storeBlockValues(_ tap: Signal<Void>){
        
        let pipe = BehaviorSubject<[BlockObject?]>(value: [nil])
        toBlockObservable = pipe.asObservable()
        
        tap
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .flatMap{ owend, _ in
                owend.paragraphTrackingUtility
                .getBlockObjectObservable()
                .withLatestFrom(pipe){ newObject , original in
                    print("block1 ; \(newObject)")
                    newObject.forEach{_ in
                        
                    }
                    return newObject
                }
            }
            .withUnretained(self)
            .flatMap{ owend ,value in owend.service!.rxAddBlockObjectDatas(value) }
            .subscribe(onNext: {  blocks in
                
                print("block3 ; \(blocks)")
            })
            .disposed(by: disposeBag)
    }
    
    
    func createBlockAttributeInput(_ blockType: CustomBlockType.Base,_ current: NSRange,_ disposeBag: DisposeBag){
        //        return self.paragraphTrackingUtility.addBlockActionPropertyToTextStorage(blockType, current)
        let relay = BehaviorSubject<(CustomBlockType.Base,NSRange)>(value: (.none,NSRange()))
        
        relay
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self ,(.none, NSRange())))
            .drive(onNext: { owned,tuple in
                let (blockType, currentRange) = tuple
                owned.paragraphTrackingUtility.addBlockActionPropertyToTextStorage(blockType, currentRange)
                print("Resource count \(RxSwift.Resources.total)")

            },onDisposed: {
                print("Resource disposed count \(RxSwift.Resources.total)")
            })
            .disposed(by: disposeBag)
        
        relay.onNext((blockType,current))
        
    }
    
    func removePlaceHolderAttribute(_ attributes: [NSAttributedString.Key : Any], _ location: Int){
        let relay = PublishSubject<([NSAttributedString.Key : Any],Int)>()
        
        relay
            .withUnretained(self)
            .subscribe(onNext: { owned,tuple in
                let (key, location) = tuple
                
                owned.paragraphTrackingUtility.resetPlace(key, location)
            })
            .disposed(by: disposeBag)
        
        relay.onNext((attributes,location))
        relay.onCompleted()
    }
    
    func replaceBlockAttribute(_ text: String,_ paragraphRange: NSRange,_ blockType: CustomBlockType.Base) -> Bool{
        switch blockType {
        case .page:
            return true
        case .title1:
            return self.paragraphTrackingUtility.replaceTitleAttributes(text, paragraphRange, .title1)
        case .title2:
            return self.paragraphTrackingUtility.replaceTitleAttributes(text, paragraphRange, .title2)
        case .title3:
            return self.paragraphTrackingUtility.replaceTitleAttributes(text, paragraphRange, .title3)
        case .graph:
            return true
        case .textHeadSymbolList,.toggleList, .todoList:
            return self.paragraphTrackingUtility.replaceToggleAttribues(text,paragraphRange,blockType)
        case .numberList:
            return true
        case .quotation:
            return true
        case .separatorLine:
            return true
        case .pageLink:
            return true
        case .callOut:
            return true
        case .none:
            return true
        default:
            return true
        }
     
    }
}
