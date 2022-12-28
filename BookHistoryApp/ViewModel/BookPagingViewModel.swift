//
//  BookPagingViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/23.
//

import Foundation
import RxSwift
import CoreData
import RxRelay

protocol PagingType {
    
    //input
    var onPaging: AnyObserver<Void> { get }
    
    var pageData: AnyObserver<[BookMO]> { get }
    
    var movePage: AnyObserver<BookMO> { get }
    
    var deletePage: AnyObserver<Void> { get }
    
    //output
    var showPage: Observable<[BookMO]> { get }
}

enum Book{
    case book
}

class BookPagingViewModel: NSObject, PagingType{
    
    var onPaging: AnyObserver<Void>
    
    var pageData: AnyObserver<[BookMO]>
    
    var movePage: AnyObserver<BookMO>
    
    var showPage: Observable<[BookMO]>
    
    var deletePage: AnyObserver<Void>
    
    var disposeBag = DisposeBag()
    
    
    init(_ serviece: RxBookService = BookService() ) {
        
        let pagingPipe = PublishSubject<Void>()
        
        let pageDataPipe = PublishSubject<[BookMO]>()
        
        let movePipe = PublishSubject<BookMO>()
        
        let showPipe = BehaviorRelay<[BookMO]>(value: [])
        
        let deletePipe = PublishSubject<Void>()
        
        onPaging = pagingPipe.asObserver()
        
        pageData = pageDataPipe.asObserver()
        movePage = movePipe.asObserver()
        
        showPage = showPipe.asObservable()
        
        
        deletePage = deletePipe.asObserver()
        
        // Data flow
        // onPaging -> pagingPipe -> Service -> pageDataPipe -> showPipe -> showPage
        
        super.init()
        
        pagingPipe
            .flatMap(serviece.rxGetPages)
            .subscribe(onNext: pageDataPipe.onNext(_:))
            .disposed(by: disposeBag)
        
        pageDataPipe
            .subscribe(onNext: showPipe.accept(_:))
            .disposed(by: disposeBag)
        
        deletePipe
            .flatMap(serviece.rxDeletePage)
            .subscribe(onNext: { flag in
                
            })
            .disposed(by: disposeBag)
    }
}
