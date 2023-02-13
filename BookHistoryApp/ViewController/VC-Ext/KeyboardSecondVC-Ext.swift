//
//  SecondVC-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension Notification{
    static var keyDown: Notification.Name = Notification.Name("keyDown")
    
    static var changeInputView: Notification.Name = Notification.Name("changeInputView")
    
    static var changeOriginalKeyBoard: Notification.Name = Notification.Name("originalKeyBoard")
}

extension SecondViewController{
    
    
    /// KeyBoard notification
    func settingKeyBoardNotification() {
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyDownTapped), name: Notification.keyDown, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyBoardchangeInputViewAction), name: Notification.changeInputView, object: nil)
        
        NotificationCenter
            .default
            .addObserver(self, selector: #selector(keyBoardChangeOriginal), name: Notification.changeOriginalKeyBoard, object: nil)
    }
    
    
    @objc private func keyBoardChangeOriginal(_ notification: Notification?) -> Void {
        
        pageViewModel.keyBoardChangeOriginal()
        
        self.keyBoardDisposeBag = DisposeBag()
        self.textView.inputView = nil
        self.textView.reloadInputViews()
    }
    
    @objc private func addColorTapped(_ sender: Any){
        self.textView.textStorage.setAttributes([
            NSAttributedString.Key.backgroundColor : UIColor.systemPink,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.systemPink
        ], range: self.textView.selectedRange)
    }
    
    
    @objc private func keyBoardchangeInputViewAction(_ notification: Notification?) -> Void {
        pageViewModel.keyBoardChangeInputViewAction()
    }
    
    @objc private func keyDownTapped(_ notification: Notification?) -> Void {
        pageViewModel.keyDownTapped()
        self.hideTextMenuView()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification?) -> Void{
        pageViewModel.keyboardWillHide()
    }
    
    @objc private func keyboardDidShow(_ notification: Notification?) -> Void{
        pageViewModel.keyboardDidShow(notification)
    }
    
    
    @objc private func keyboardWillShow(_ notification : Notification?) -> Void {
        pageViewModel.keyboardWillShow()
    }
    
    
    func hideTextMenuView() {
        self.view.layoutIfNeeded()
        
        self.textView.endEditing(true)
        
        textView.snp.updateConstraints{
            $0.bottom.equalToSuperview().inset(16)
        }
        
        if textView.textContentHeightFlag == true{
            textView.contentSize.height += 500
            textView.textContentHeightFlag = false
        }
    }
    
    
    //When keyBoard appear setUndoManager
    func keyBoardAppearLayout(_ kbSize: CGSize){
        setUndoManager()
        textView.snp.updateConstraints{
            $0.bottom.equalToSuperview().inset(kbSize.height)
        }
    }
    
    private func setUndoManager(){
        self.textMenuView.textViewUndoManager = self.textView.undoManager
    }
}

