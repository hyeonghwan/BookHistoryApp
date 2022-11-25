//
//  InputViewViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/21.
//

import Foundation
import RxSwift


enum KeyBoardState: String {
    case originalkeyBoard
    case backAndForeGroundColorState
}

protocol InputViewModelType {

    // input
    var inputStateObserver: AnyObserver<KeyBoardState> { get }
    
    //output
    var ouputStateObservable: Observable<KeyBoardState> { get }
}

class InputViewModel: NSObject, InputViewModelType {
    
    
    var inputStateObserver: AnyObserver<KeyBoardState>
    
    var ouputStateObservable: Observable<KeyBoardState>
    
    private var disposeBag = DisposeBag()
    
    override init() {
        
        //input
        let inputKeyBoardStateSubject = PublishSubject<KeyBoardState>()
        
        // output
        let outputKeyBoardStateSubject = BehaviorSubject<KeyBoardState>(value: .originalkeyBoard)
        
        inputStateObserver = inputKeyBoardStateSubject.asObserver()
        
        ouputStateObservable = outputKeyBoardStateSubject
        
        super.init()
        
        inputKeyBoardStateSubject
            .subscribe(onNext: outputKeyBoardStateSubject.onNext(_:))
            .disposed(by: disposeBag)
            
        
        
    }
    
}
