//
//  SecondVC-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/15.
//

import UIKit

extension SecondViewController{
    
    
    /// KeyBoard notification
    func settingKeyBoardNotification() {
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc private func keyboardWillHide(_ notification: Notification?) -> Void{
        print("keyboardWillHide")
    }
    
    @objc private func keyboardWillShow(_ notification : Notification?) -> Void {
           
           var _kbSize:CGSize!
           
           if let info = notification?.userInfo {

               let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
               
               //  Getting UIKeyboardSize.
               if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                   
                   let screenSize = UIScreen.main.bounds
                   
                   //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                   let intersectRect = kbFrame.intersection(screenSize)
                   
                   if intersectRect.isNull {
                       _kbSize = CGSize(width: screenSize.size.width, height: 0)
                   } else {
                       _kbSize = intersectRect.size
                   }
                   print("Your Keyboard Size \(_kbSize)")
                   self.view.addSubview(textMenuView)
                   textMenuView.snp.makeConstraints{
                       $0.width.equalTo(_kbSize.width)
                       $0.height.equalTo(_kbSize.height + 44)
                       $0.bottom.equalToSuperview()
                   }
               }
           }
       }
}

