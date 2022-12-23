//
//  BookContentViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//

import Foundation
import RxSwift
import CoreData


protocol ContentViewModelType {
    
    //input
    var onTextViewData: AnyObserver<BookViewModelData> { get }
    var onParagraphData: AnyObserver<NSAttributedString> {get}
    
    //OUtPut
    var textObservable: Observable<BookViewModelData> { get }
    
    //utility
    var paragraphTrackingUtility: ParagraphTrackingUtility { get }
}
struct TextViewData{
    let id: UUID?
    let title: String?
    let attributedString: NSAttributedString?
    init(){
        self.id = nil
        self.title = nil
        self.attributedString = nil
    }
    init(id: UUID?, title: String?, attributedString: NSAttributedString?) {
        self.id = id
        self.title = title
        self.attributedString = attributedString
    }
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

class BookContentViewModel: NSObject, ContentViewModelType{
    
    var paragraphTrackingUtility: ParagraphTrackingUtility = ParagraphTrackingUtility()
    
    var onParagraphData: AnyObserver<NSAttributedString>
    
    var onTextViewData: AnyObserver<BookViewModelData>
    
    var textObservable: Observable<BookViewModelData>
    
    var disposeBag = DisposeBag()
    
    var container: NSPersistentContainer?
    
    init(_ serviece: RxBookService = BookService()) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        container = appDelegate.persistentContainer
        
        let paragraphPipe = PublishSubject<NSAttributedString>()
        let textViewDataPipe = PublishSubject<BookViewModelData>()
        let observablePipe = BehaviorSubject<BookViewModelData>(value: BookViewModelData())
        
        onParagraphData = paragraphPipe.asObserver()
        
        onTextViewData = textViewDataPipe.asObserver()
        
        textObservable = observablePipe
        
       
        super.init()
        
        paragraphPipe
            .withLatestFrom(observablePipe){[weak self] textViewAttributedString, original in
                guard let self = self else {return TextViewData()}
                return self.getTextViewData(textViewAttributedString, original)
            }
            .flatMap(serviece.rxAddParagraphData(_:))
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
        
    }
    
    private func getTextViewData(_ attributedString: NSAttributedString,
                                 _ bookViewModelData: BookViewModelData) -> TextViewData{
        guard bookViewModelData.id != nil else { return TextViewData(id: nil,
                                                                     title: self.paragraphTrackingUtility.paragraphs.first!,
                                                                     attributedString: attributedString) }
        return TextViewData(id: bookViewModelData.id,
                            title: self.paragraphTrackingUtility.paragraphs.first!
                            ,attributedString: attributedString)
    }
}
