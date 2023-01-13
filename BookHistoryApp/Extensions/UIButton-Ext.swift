//
//  UIButton-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/02.
//

import UIKit
import RxSwift
import RxCocoa

extension UIButton {
    
    func inputAccessoryButton_Frame_Color_Image_Action_Setting(_ buttonType: MenuButtonType){
        
        guard let accessoryViewModel = buttonType.viewModel else {return}
        guard let type = buttonType.type else {return}
        guard let disposeBag = buttonType.disposeBag else {return}
        guard let image = buttonType.image else {return}
        guard let frame = buttonType.frame else {return}
        guard let color = buttonType.color else {return}
        
        self.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { _ in 
                accessoryViewModel.inputActionObserver.onNext(type)
            }).disposed(by: disposeBag)
        
        
        self.setImage(UIImage(systemName: image) ?? UIImage(systemName: "book"), for: .normal)
        self.frame = frame
        self.tintColor = color
    
    }
}
