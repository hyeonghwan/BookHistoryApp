//
//  ParagraphUtility-ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/16.
//

import ParagraphTextKit
import RxSwift
import RxRelay
import RxCocoa

protocol BlockToggleAction{
    func createToggleObservable(_ toggle: Driver<Bool>)
}

extension ParagraphTrackingUtility: BlockToggleAction{
 
    func createToggleObservable(_ toggle: Driver<Bool>) {
        toggle
            .drive(onNext: { [weak self] flag in
                guard let self = self else {return}
                print(flag)
                print("createToggleObservable : \(self)")
            }).disposed(by: disposeBag)
    }
}
                                      
