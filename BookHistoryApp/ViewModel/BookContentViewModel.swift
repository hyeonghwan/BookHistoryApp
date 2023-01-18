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
    
    func createBlockAttributeInput(_ blockType: BlockType,_ current: NSRange)

    func removePlaceHolderAttribute(_ attributes: [NSAttributedString.Key : Any], _ range: Int)
    
    func replaceBlockAttribute(_ text: String,_ paragraphRange: NSRange) -> Bool
    
    //OUtPut
    var toTextObservable: Observable<BookViewModelData> { get }
    
    var toParagraphBlockTypeEventResult: Observable<BlockType>? { get }
    
    //utility
    var paragraphTrackingUtility: ParagraphTrackingUtility { get }
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


typealias ContentViewModelProtocol = ContentViewModelType & ContentVMBooMarkAble


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
    
    
    
    var paragraphTrackingUtility: ParagraphTrackingUtility = ParagraphTrackingUtility()
    
    //MARK: ContentViewModelType
    //input
    var onParagraphData: AnyObserver<NSAttributedString>
    
    var onTextViewData: AnyObserver<BookViewModelData>
    
    
    //outPUT Block EventType
    var toParagraphBlockTypeEventResult: Observable<BlockType>?
    
    //outPUT
    var toTextObservable: Observable<BookViewModelData>
    
    
    //MARK: ContentVMBooMarkAble
    var isPasteValue: Bool = false
    
    //input
    var onURLData: AnyObserver<URL>
    var onPasteValue: AnyObserver<Bool>
    
    //output
    var toMetaDataURL: Observable<MetaDataDictionatyOnURL>
    
    
    
    var disposeBag = DisposeBag()
    
    var container: NSPersistentContainer?
    
    deinit{
        print("contentModel deinit")
    }
    
    init(_ serviece: BookServiceAble = BookService()) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        container = appDelegate.persistentContainer
        
        
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
            .flatMap(serviece.rxAddParagraphData(_:))
            
            .subscribe(onNext: {  result in
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
            .flatMap(serviece.makeBookMark(_:))
            .subscribe(onNext: metaDataPipe.onNext(_:))
            .disposed(by: disposeBag)
      
        
        pastePipe
            .bind(onNext: { [weak self] value in
                guard let self = self else {return}
                self.isPasteValue = value
            })
            .disposed(by: disposeBag)
    }
    
    func createBlockAttributeInput(_ blockType: BlockType,_ current: NSRange){
        let relay = BehaviorRelay<(BlockType,NSRange)>(value: (.none,NSRange()))
        
        relay.accept((blockType,current))
        
        relay
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self ,(.none, NSRange())))
            .drive(onNext: { owned,tuple in
                let (blockType, currentRange) = tuple
                owned.paragraphTrackingUtility.addBlockActionPropertyToTextStorage(blockType, currentRange)
            })
            .disposed(by: disposeBag)
    }
    
    func removePlaceHolderAttribute(_ attributes: [NSAttributedString.Key : Any], _ location: Int){
//        self.paragraphTrackingUtility.resetPlace(attributes, location)
        let relay = PublishSubject<([NSAttributedString.Key : Any],Int)>()
        
        relay
            .withUnretained(self)
            .subscribe(onNext: { owned,tuple in
                let (key, location) = tuple
                print("resetPlace")
                owned.paragraphTrackingUtility.resetPlace(key, location)
            })
            .disposed(by: disposeBag)
        
        relay.onNext((attributes,location))
        relay.onCompleted()
    }
    
    func replaceBlockAttribute(_ text: String,_ paragraphRange: NSRange) -> Bool{
        return self.paragraphTrackingUtility.replaceToggleAttribues(text,paragraphRange)
    }
}
