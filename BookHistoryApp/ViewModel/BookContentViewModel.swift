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
    var onParagraphData: AnyObserver<NSAttributedString> {get}
}

class BookContentViewModel: NSObject, ContentViewModelType{
    
    var onParagraphData: AnyObserver<NSAttributedString>
    
    var disposeBag = DisposeBag()
    
    var container: NSPersistentContainer?
    
    init(_ serviece: RxBookService = BookService()) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        container = appDelegate.persistentContainer
        
        let paragraphPipe = PublishSubject<NSAttributedString>()
        
        onParagraphData = paragraphPipe.asObserver()
        
        super.init()
        
        paragraphPipe
            .flatMapLatest(serviece.rxAddParagraphData)
            .subscribe(onNext: {  result in
                switch result{
                case .success(_):
                    print("add success")
                case .failure(let error):
                    print("error occur: \(error)")
                }
            })
            .disposed(by: disposeBag)
        
    }
}
