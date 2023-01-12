//
//  TextView-BlockAction-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/12.
//

import UIKit
import RxSwift
import RxCocoa


extension SecondTextView {
    
    func setUpBlockActionBinding(){
        let output = blockVM.createBlockActionOutPut()
        output.outPut?
            .emit(onNext: { type in
                print("type ::: \(type)")
                
            }).disposed(by: disposeBag)
    }
}
