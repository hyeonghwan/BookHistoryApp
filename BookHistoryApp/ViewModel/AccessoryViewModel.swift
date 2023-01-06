//
//  TextAccessoryViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/03.
//

import Foundation
import RxSwift

protocol AccessoryViewModelProtocol{
    func action(_ type: MenuActionType)
}

protocol InputActionProtocol{
    var inputActionObserver: AnyObserver<MenuActionType> { get }
}

protocol OutputActionProtocol{
    var outPutActionObservable: Observable<MenuActionType> { get }
}

typealias AccessoryCompositionProtocol = OutputActionProtocol & InputActionProtocol

final class AccessoryViewModel: NSObject,AccessoryCompositionProtocol {
    
    var outPutActionObservable: Observable<MenuActionType>
    
    var inputActionObserver: AnyObserver<MenuActionType>
    
    var disposeBag = DisposeBag()
    
    override init() {
        
        let inputActionPipe = PublishSubject<MenuActionType>()
        let outPutActionPipe = PublishSubject<MenuActionType>()
        
        inputActionObserver = inputActionPipe.asObserver()
        outPutActionObservable = outPutActionPipe
        
        super.init()
        
        inputActionPipe
            .bind(to: outPutActionPipe)
            .disposed(by: disposeBag)

    }
    
}
