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
                print("type: \(type)")
                
                print("self.selectedRange : \(self.selectedRange)")
                
                let currentParagraphRange = self.getParagraphRange(self.selectedRange)
                
                let text = self.text(in: self.textRangeFromNSRange(range: currentParagraphRange)!)
                
                print("text: \(text)")
                print("text: \(text?.count)")
                print("text: \(text?.length)")
                print("currentParagraphRange settup: \(currentParagraphRange)")
                self.contentViewModel?.createBlockAttributeInput(type,currentParagraphRange,self.disposeBag)
            },onDisposed: {
                print("onDisposed :")
            }).disposed(by: disposeBag)
    }
}
