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
    
//    let swipeGesture = CustomSwipeGesture(target: self, action: #selector(self.swipeAction(gesture:)))
//    swipeGesture.text = "원하는 정보"
//    swipeGesture.direction = .up
//    myTaget.addGestureRecognizer(swipeGesture)
    
    func inputAccessoryButton_Frame_Color_Image_Action_Setting(_ buttonType: MenuButtonType){
    
        
        guard let viewModel = buttonType.viewModel else {return}
        guard let type = buttonType.type else {return}
        guard let disposeBag = buttonType.disposeBag else {return}
        guard let image = buttonType.image else {return}
        guard let frame = buttonType.frame else {return}
        guard let color = buttonType.color else {return}
        
        self.rx.tap
            .bind(onNext: {
                viewModel.inputActionObserver.onNext(type)
            }).disposed(by: disposeBag)
        
        
        self.setImage(UIImage(systemName: image) ?? UIImage(systemName: "book"), for: .normal)
        settingFrame(frame)
        settingTintColor(color)
    
    }
    
    private func settingFrame(_ frame: CGRect){
        self.frame = frame
    }
    
    private func settingTintColor(_ color: UIColor){
        self.tintColor = color
    }
    
}
