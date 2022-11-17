//
//  SecondVC-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/15.
//

import UIKit
import SnapKit

extension Notification{
    static var keyDown: Notification.Name = Notification.Name("keyDown")
}

extension SecondViewController{
    
    
    /// KeyBoard notification
    func settingKeyBoardNotification() {
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyDownTapped), name: Notification.keyDown, object: nil)
    }
    
    
    @objc private func addColorTapped(_ sender: Any){
        self.textView.textStorage.setAttributes([
            NSAttributedString.Key.backgroundColor : UIColor.systemPink,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.systemPink
        ], range: self.textView.selectedRange)
    }
    
    @objc private func keyDownTapped(_ notification: Notification?) -> Void {
        print("keyDownTapped")
        self.textView.endEditing(true)
        self.textMenuView.removeFromSuperview()
        self.keyBoardDisapearLayout()
        
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
                   print("Your Keyboard Size \(String(describing: _kbSize))")
                   
                   
                   showTextMenuView(kbFrame, 44)
                   
                   self.setKeyboardHeight(_kbSize.height)
                   
                   self.keyBoardAppearLayout(_kbSize)
                
               }
               
           }
       }
    //(375.0, 291.0))
    
    func showTextMenuView(_ kbFrame: CGRect,
                          _ height: CGFloat) {
        print("showTextMenuView")
//        UIApplication.shared.keyWindow?.addSubview(textMenuView)
        self.view.addSubview(textMenuView)
        textMenuView.settingFrame(kbFrame, height)
        
    }
    
    private func keyBoardAppearLayout(_ kbSize: CGSize){
        self.view.layoutIfNeeded()
        
        textView.snp.remakeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(kbSize.height + 44)
            $0.width.equalTo(self.view.snp.width).offset(-36)
        }
    }
    
    private func keyBoardDisapearLayout(){
        self.view.layoutIfNeeded()
        textView.snp.remakeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.width.equalTo(self.view.snp.width).offset(-36)
        }
    }
}

