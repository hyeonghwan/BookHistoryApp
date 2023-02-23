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
        let output = blockVM?.createBlockActionOutPut()
        output?.blockActionOutput?
            .drive(onNext: { [weak self] type in
                guard let self = self else {return}
                
                let currentParagraphRange = self.getParagraphRange(self.selectedRange)
                
                let text = self.text(in: self.textRangeFromNSRange(range: currentParagraphRange)!)
                
                self.contentViewModel?.createBlockAttributeInput(type,currentParagraphRange,self.disposeBag)
            },onDisposed: {
                print("onDisposed :")
            }).disposed(by: disposeBag)
    }
}
