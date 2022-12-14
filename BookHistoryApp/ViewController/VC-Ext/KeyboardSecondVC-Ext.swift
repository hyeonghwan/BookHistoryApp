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
        self.inputViewModel.inputStateObserver.onNext(.originalkeyBoard)
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
        
        if let state = self.textMenuView.state,
           state != .backAndForeGroundColorState{
            
            self.inputViewModel.inputStateObserver.onNext(.backAndForeGroundColorState)
            
            let backGroundPickerView = BackORForeColorPickerView()
            
            backGroundPickerView
                .buttonObservable
                .bind(onNext: colorViewModel.onColorData.onNext(_:))
                .disposed(by: keyBoardDisposeBag)
            
            backGroundPickerView.translatesAutoresizingMaskIntoConstraints = false
            
            self.textView.inputView = backGroundPickerView
            
            self.textView.reloadInputViews()
           
        }
    }
    
    @objc private func keyDownTapped(_ notification: Notification?) -> Void {
        self.hideTextMenuView()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification?) -> Void{
        inputViewModel.inputLongPressObserver.onNext(true)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification?) -> Void{
        var _kbSize:CGSize!
        
        if let info = notification?.userInfo{
            
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
                
                
                bindingInputAccessoryView()
                
                self.setKeyboardHeight(_kbSize.height)
                
                self.keyBoardAppearLayout(_kbSize)
            }
        }
    }
    
    @objc private func keyboardWillShow(_ notification : Notification?) -> Void {
        inputViewModel.inputLongPressObserver.onNext(true) //false
    }
    
    
    // bind viewModelState to textMenuView( KeyBoard InPutView State)
    func bindingInputAccessoryView() {
            inputViewModel
                .ouputStateObservable
                .bind(to: textMenuView.rx.state)
                .disposed(by: disposeBag)
            
            colorViewModel
                .updateUndoButtonObservable
                .bind(onNext: updateUndoButtons)
                .disposed(by: keyBoardDisposeBag)
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
    private func setUndoManager(){
        self.textMenuView.textViewUndoManager = self.textView.undoManager
    }
    
    private func keyBoardAppearLayout(_ kbSize: CGSize){
        
        setUndoManager()
        
        textView.snp.updateConstraints{
            $0.bottom.equalToSuperview().inset(kbSize.height)
        }
    }

}

