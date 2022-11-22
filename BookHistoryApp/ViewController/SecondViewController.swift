//
//  SecondViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol SecondTextViewScrollDelegate {
    func scrollPostion(_ range: UITextRange)
    func textDidChagned()
}

class SecondViewController: UIViewController {

    var inputViewModel: InputViewModelType = InputViewModel()
    
    var colorViewModel: ColorVMType = ColorViewModel()
    
    var disposeBag = DisposeBag()
    
    var previousRect = CGRect.zero
    
    var keyBoardDisposeBag = DisposeBag()
    
    let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                          y: 0.0,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44.0))//1
    
    private var keyBoardHeight: CGFloat = 0
    
    
    lazy var textMenuView: TextPropertyMenuView = {
        let menu = TextPropertyMenuView(frame:  CGRect(x: 0, y: self.view.frame.size.height,
                                                       width: UIScreen.main.bounds.size.width, height: 10),
                                        viewModel: self.inputViewModel)
        menu.backgroundColor = .tertiarySystemBackground
        return menu
    }()
    
    
    lazy var textView: SecondTextView = {
        let textView = SecondTextView(frame:.zero,
                                      textContainer: CustomTextContainer(size: .zero),
                                      colorViewModel)
        
        textView.delegate = self
        return textView
    }()
    
    
    private lazy var container: UIView =    {
        let view = UIView()
        return view
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(textView)

        self.addAutoLayout()
        
        container.backgroundColor = .systemPink
        
        self.settingKeyBoardNotification()
        
        textView.backgroundColor = .tertiarySystemBackground
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let self = self else {return}
            self.textView.contentSize.height += 500
            
        })
    
    }
    
    private func addAutoLayout() {
        
        textView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textMenuView.removeFromSuperview()
        
    }
    
    // bind viewModelState to textMenuView
    func showTextMenuView(_ kbFrame: CGRect,
                          _ height: CGFloat) {
        
        //        UIApplication.shared.keyWindow?.addSubview(textMenuView)
        if !self.view.subviews.contains(where: { view in view == textMenuView}){
            self.view.addSubview(textMenuView)
            
            textMenuView.settingFrame(kbFrame, height)
            
            inputViewModel
                .ouputStateObservable
                .bind(to: textMenuView.rx.state)
                .disposed(by: disposeBag)
            
            colorViewModel
                .updateUndoButtonObservable
                .bind(onNext: updateUndoButtons)
                .disposed(by: keyBoardDisposeBag)
            
        }
    }

    
    func setKeyboardHeight(_ height: CGFloat){
        self.keyBoardHeight = height
    }
    
    func getKeyboardHeight() -> CGFloat {
        return self.keyBoardHeight
    }

    
    private func updateUndoButtons() {
        textMenuView.undoButton.isEnabled = textView.undoManager?.canUndo ?? false
        textMenuView.redoButton.isEnabled = textView.undoManager?.canRedo ?? false
    }
    
    
}

extension SecondViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        self.textView.typingAttributes = [
//            NSAttributedString.Key.backgroundColor : UIColor.clear,
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
//            NSAttributedString.Key.foregroundColor : UIColor.label
//        ]
        return true
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.typingAttributes = [
                NSAttributedString.Key.backgroundColor : UIColor.clear,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
                NSAttributedString.Key.foregroundColor : UIColor.label
            ]
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUndoButtons()
        
    }
}


extension SecondViewController {
    
    func addDoneButton(title: String, selector: Selector) {
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
        
        self.toolBar.items?.append(barButton)
    }
    
    func addColorBlockButton(title: String, selector: Selector){
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
    
        self.toolBar.items?.append(barButton)
    }
    
}


