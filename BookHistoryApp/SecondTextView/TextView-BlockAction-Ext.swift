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
        output.blockActionOutput?
            .drive(onNext: { [weak self] type in
                guard let self = self else {return}
                print("type: \(type)")
                let currentParagraphRange = self.getParagraphRange(self.selectedRange)
                self.contentViewModel?.createBlockAttributeInput(type,currentParagraphRange)
            },onDisposed: {
                print("onDisposed :")
            }).disposed(by: disposeBag)
    }
}
