//
//  TextAccessoryViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol AccessoryViewModelProtocol{
    func action(_ type: MenuActionType)
}

protocol InputActionProtocol: AnyObject{
    var inputActionObserver: AnyObserver<MenuActionType> { get }
    
    var imageAddActionEvent: PublishRelay<ContextMenuEventType> { get }
}

protocol OutputActionProtocol: AnyObject{
    var outPutActionObservable: Observable<MenuActionType> { get }
    
}

typealias AccessoryCompositionProtocol = OutputActionProtocol & InputActionProtocol

final class AccessoryViewModel: NSObject,AccessoryCompositionProtocol {
    var imageAddActionEvent: PublishRelay<ContextMenuEventType> = PublishRelay<ContextMenuEventType>()
    
    var imageContextMenuTrigger: PublishRelay<Void>?
    
    
    var outPutActionObservable: Observable<MenuActionType>
    
    var inputActionObserver: AnyObserver<MenuActionType>
    
    
    var pipe = PublishSubject<ContextMenuEventType>()
    var disposeBag = DisposeBag()
    
    deinit{
        print("AccessoryViewModel deinit")
    }
    override init() {
        
        let inputActionPipe = PublishSubject<MenuActionType>()
        let outPutActionPipe = PublishSubject<MenuActionType>()
        
        inputActionObserver = inputActionPipe.asObserver()
        outPutActionObservable = outPutActionPipe
    
        super.init()
        
        inputActionPipe
            .observe(on: MainScheduler.instance)
            .bind(to: outPutActionPipe)
            .disposed(by: disposeBag)

        imageAddActionEvent
            .skip(1)
            .asSignal(onErrorJustReturn: .photoLibrary)
            .emit(onNext: { k in
                
            }).disposed(by: disposeBag)
    }
    
    
}
