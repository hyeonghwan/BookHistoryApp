//
//  BookPagingViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/23.
//

import Foundation
import RxSwift

protocol PagingType {
    
    //input
    var onPaging: AnyObserver<Void> { get }
    
    //output
    var showPage: Observable<Book> { get }
}

enum Book{
    case book
}

class BookPagingViewModel: NSObject, PagingType{
    
    var onPaging: AnyObserver<Void>
    
    var showPage: Observable<Book>
    
    override init() {
        let pagingPipe = PublishSubject<Void>()
        let showPipe = PublishSubject<Book>()
        
        onPaging = pagingPipe.asObserver()
        showPage = showPipe
        super.init()
        
        
    }
}
