//
//  BookContentViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//

import Foundation
import RxSwift
import CoreData
import OpenGraph


protocol ContentViewModelType {
    
    //input
    var onTextViewData: AnyObserver<BookViewModelData> { get }
    var onParagraphData: AnyObserver<NSAttributedString> {get}
    
    //OUtPut
    var toTextObservable: Observable<BookViewModelData> { get }
    
    //utility
    var paragraphTrackingUtility: ParagraphTrackingUtility { get }
}

protocol ContentVMBooMarkAble{
    //input
    var onURLData: AnyObserver<URL> { get }
    
    //output
    var toMetaDataURL: Observable<MetaDataDictionatyOnURL> { get }
}

typealias ContentVMTypeAble = ContentViewModelType & ContentVMBooMarkAble


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

class BookContentViewModel: NSObject, ContentVMTypeAble{
    
    var paragraphTrackingUtility: ParagraphTrackingUtility = ParagraphTrackingUtility()
    
    //MARK: ContentViewModelType
    //input
    var onParagraphData: AnyObserver<NSAttributedString>
    
    var onTextViewData: AnyObserver<BookViewModelData>
    
    //outPUT
    var toTextObservable: Observable<BookViewModelData>
    
    
    //MARK: ContentVMBooMarkAble
    //input
    var onURLData: AnyObserver<URL>
    
    //output
    var toMetaDataURL: Observable<MetaDataDictionatyOnURL>
    
    
    
    var disposeBag = DisposeBag()
    
    var container: NSPersistentContainer?
    
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
      
        
    }
}
