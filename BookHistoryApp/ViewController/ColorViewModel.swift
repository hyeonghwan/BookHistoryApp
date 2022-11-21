//
//  ColorViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/21.
//

import Foundation
import RxCocoa
import RxSwift


protocol ColorVMType {
    // input
    var onColorData: AnyObserver<PresentationType> { get }
    
    var onUndoActivity: AnyObserver<Void> { get }
    
    //output
    var attributedStringObservable: Observable<PresentationType> { get }
    
    var updateUndoButtonObservable: Observable<Void> { get }
}

class ColorViewModel: NSObject, ColorVMType {
    
    // input
    var onColorData: AnyObserver<PresentationType>
    var onUndoActivity: AnyObserver<Void>
    
    // output
    var attributedStringObservable: Observable<PresentationType>
    var updateUndoButtonObservable: Observable<Void>
    
    
    var disposeBag = DisposeBag()
    
    override init() {
        let colorPipe = PublishSubject<PresentationType>()
        onColorData = colorPipe.asObserver()
        

        let undoActivityPipe = PublishSubject<Void>()
        onUndoActivity = undoActivityPipe.asObserver()
        
        
        let attributedColorPipe = PublishSubject<PresentationType>()
        attributedStringObservable = attributedColorPipe
        
        
        let updateUndoPipe = PublishSubject<Void>()
        updateUndoButtonObservable = updateUndoPipe
        
        super.init()
        
        colorPipe
            .bind(to: attributedColorPipe)
            .disposed(by: disposeBag)
        
        undoActivityPipe
            .bind(to: updateUndoPipe)
            .disposed(by: disposeBag)
            
        
    }
}
