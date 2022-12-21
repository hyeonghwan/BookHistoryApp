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
import ParagraphTextKit

protocol SecondTextViewScrollDelegate {
    func scrollPostion(_ range: UITextRange)
    func textDidChagned()
}

class SecondViewController: UIViewController {
    
    let titlePresentationKey: String = "Title"
    lazy var titleAttribute = NSAttributedString(string: "제목을 입력해주세요",
                                            attributes: [.foregroundColor : UIColor.lightGray,
                                                         .font : UIFont.boldSystemFont(ofSize: 20),
                                        .presentationIntentAttributeName : titlePresentationKey])

    
    private var paragraphTextStorage = ParagraphTextStorage()

    
    // KeyBoard InputViewType State ViewModel
    var inputViewModel: InputViewModelType = InputViewModel()
    
    // TextView Color Type State ViewModel
    var colorViewModel: ColorVMType = ColorViewModel()
    
    // TextView Save Content State ViewModel
    var contentViewModel: ContentViewModelType = BookContentViewModel()
    
    
    var bookPagingViewModel: PagingType?
    
    
    var disposeBag = DisposeBag()
    
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
 
        self.paragraphTextStorage.paragraphDelegate = self
        
        let layoutManager = TextWrapLayoutManager()

        self.paragraphTextStorage.addLayoutManager(layoutManager)

        let textContainer = CustomTextContainer(size: .zero)

        layoutManager.addTextContainer(textContainer)
        
        let textView = SecondTextView(frame:.zero,
                                      textContainer: textContainer,
                                      colorViewModel)
        
        textView.delegate = self
        
        return textView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(textView)

        self.addAutoLayout()
        
        self.settingKeyBoardNotification()
        
        textView.backgroundColor = .tertiarySystemBackground
        
        settingNavigation()
        
        addTextViewTitlePlaceHolder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let self = self else {return}
            self.textView.contentSize.height += 500
            
        })
        
    }
    

    private func settingNavigation(){

//        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.tintColor = .systemCyan
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)

        
        self.navigationItem.rightBarButtonItem?.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.contentViewModel
                    .onParagraphData
                    .onNext(self.textView.attributedText)
                
            }).disposed(by: disposeBag)
        
    }
    
    
    
    private func addAutoLayout() {
        
        textView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func addTextViewTitlePlaceHolder() {
        textView.attributedText = titleAttribute
        textView.becomeFirstResponder()
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textMenuView.removeFromSuperview()
        
    }
    
    // bind viewModelState to textMenuView( KeyBoard InPutView State)
    func showTextMenuView(_ kbFrame: CGRect,
                          _ height: CGFloat) {
    
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

extension SecondViewController: ParagraphTextStorageDelegate{
    var presentedParagraphs: [NSAttributedString] {
        return []
    }
    
    func textStorage(_ textStorage: ParagraphTextKit.ParagraphTextStorage, didChangeParagraphs changes: [ParagraphTextKit.ParagraphTextStorage.ParagraphChange]) {
        
    }
    
}

extension SecondViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {

        if textView.attributedText.string == titleAttribute.string{
           self.textView.selectedRange = NSMakeRange(0, 0)
        }else{
            return
        }
       
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(range)
        if text == "\n"{
            
            // 제목을 입력하지 않으면 "\n" 입력 -> false
            if range == NSRange(location: 0, length: 0){
                return false
            }
            textView.typingAttributes = [
                NSAttributedString.Key.backgroundColor : UIColor.clear,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
                NSAttributedString.Key.foregroundColor : UIColor.label
            ]
        }

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.attributedText = titleAttribute
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.white
            textView.text = ""
             return true
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }

    
    func textViewDidChange(_ textView: UITextView) {
        updateUndoButtons()
        
    }
}



