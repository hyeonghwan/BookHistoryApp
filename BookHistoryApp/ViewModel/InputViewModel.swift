//
//  InputViewViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/21.
//

import Foundation
import RxSwift
import RxCocoa


enum KeyBoardState: String {
    case originalkeyBoard
    case backAndForeGroundColorState
    case blockKeyBoard
    
}

protocol InputViewModelType: AnyObject {

    // input
    var inputStateObserver: AnyObserver<KeyBoardState> { get }
    
    //output
    var outputStateObservable: Observable<KeyBoardState> { get }
}

protocol InputVMLongPressAble: AnyObject{
    // input
    var inputLongPressObserver: AnyObserver<Bool> { get }
    
    // output
    var outputLongPressObservable: Observable<Bool> { get }
    
}

typealias InputViewModelProtocol = InputViewModelType & InputVMLongPressAble

class InputViewModel: NSObject, InputViewModelProtocol {
    
    
    var inputStateObserver: AnyObserver<KeyBoardState>
    
    var outputStateObservable: Observable<KeyBoardState>
    
    var inputLongPressObserver: AnyObserver<Bool>
    
    var outputLongPressObservable: Observable<Bool>
    
    
    private var disposeBag = DisposeBag()
    
    override init() {
        
        //input
        let inputKeyBoardStateSubject = PublishSubject<KeyBoardState>()
        
        // output
        let outputKeyBoardStateSubject = BehaviorSubject<KeyBoardState>(value: .originalkeyBoard)
        
        inputStateObserver = inputKeyBoardStateSubject.asObserver()
        
        outputStateObservable = outputKeyBoardStateSubject
        
        
        let inputLongPressPipe = PublishSubject<Bool>()
        
        let outputLongPressPipe = PublishSubject<Bool>()
        
        inputLongPressObserver = inputLongPressPipe.asObserver()
        
        outputLongPressObservable = outputLongPressPipe
        
        super.init()
        
        inputKeyBoardStateSubject
            .subscribe(onNext: outputKeyBoardStateSubject.onNext(_:))
            .disposed(by: disposeBag)
        
        inputLongPressPipe
            .subscribe(onNext: outputLongPressPipe.onNext(_:))
            .disposed(by: disposeBag)   
    }
}
