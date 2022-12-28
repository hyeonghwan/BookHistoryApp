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
import SubviewAttachingTextView
import WebKit

// Handles tapping on the image view attachment
class TapHandler: NSObject {
    @objc func handle(_ sender: UIGestureRecognizer!) {
        if let imageView = sender.view as? UIImageView {
            imageView.alpha = CGFloat(arc4random_uniform(1000)) / 1000.0
        }
    }
}

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
    
    // KeyBoard InputViewType State ViewModel
    var inputViewModel: InputVMTypeAble = InputViewModel()
    
    // TextView Color Type State ViewModel
    var colorViewModel: ColorVMType = ColorViewModel()
    
    // TextView Save Content State ViewModel
    var contentViewModel: ContentVMTypeAble = BookContentViewModel()
    
    
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
        
        let paragraphTextStorage = ParagraphTextStorage()
 
        paragraphTextStorage.paragraphDelegate = contentViewModel.paragraphTrackingUtility.self
        
        let layoutManager = TextWrapLayoutManager()

        paragraphTextStorage.addLayoutManager(layoutManager)
        
        let textView = SecondTextView(frame:.zero,
                                      textContainer: nil,
                                      colorViewModel,
                                      contentViewModel)
        
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
        
        settupBinding()
        
        addLongPressGesture()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.textMenuView.removeFromSuperview()
        
    }
    

    private func settingNavigation(){

//        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.tintColor = .systemCyan
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
    }
    
    private func settupBinding(){
        
        // -> TextView Content Save trigger
        self.navigationItem.rightBarButtonItem?.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.contentViewModel
                    .onParagraphData
                    .onNext(self.textView.attributedText)
            }).disposed(by: disposeBag)
        
        contentViewModel
            .toTextObservable
            .observe(on: MainScheduler.instance)
            .compactMap{ $0.bookContent }
            .bind(to: textView.rx.attributedText)
            .disposed(by: disposeBag)
        
        
        contentViewModel
            .toMetaDataURL
            .subscribe(onNext: { og in
//
            })
            .disposed(by: disposeBag)
        
        inputViewModel
            .outputLongPressObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isEnable in
                guard let self = self else {return}
                
                self.textView.isLongPressGestureEnable(isEnable)
            }).disposed(by: disposeBag)
    }

    
    private func addAutoLayout() {
        textView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    
    
    /// AddLongPressGesture to move PragraphBlcok when keyBoard not showing
    private func addLongPressGesture() {
        textView.isUserInteractionEnabled = true
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.longpress(_:)))
        uilpgr.name = "PressParaGraphBlock"
        uilpgr.minimumPressDuration = 0.5
        uilpgr.delaysTouchesBegan = true
        textView.addGestureRecognizer(uilpgr)
        uilpgr.delegate = self
    }
    
    
    @objc private func longpress(_ gestureRecognizer: UIGestureRecognizer){
        print("longPressGesture occur")
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
}
private extension SecondViewController{
    
    func addTextViewTitlePlaceHolder() {
        textView.attributedText = titleAttribute
//        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        textView.attributedText = subAttatchViewTest()
    }
    
    
    func updateUndoButtons() {
        textMenuView.undoButton.isEnabled = textView.undoManager?.canUndo ?? false
        textMenuView.redoButton.isEnabled = textView.undoManager?.canRedo ?? false
    }
        

    //정규식 으로 추가해서 URL 추출이 필요함!
    func isTextValidURL(_ text: String) -> Bool{
        var urlString = text
        urlString.removeAll(where: { $0 == "\n"})
        
        guard let url = URL(string: urlString) else {return true}
        
        contentViewModel.onURLData.onNext(url)
        return true
    }
    
    private func subAttatchViewTest() -> NSAttributedString{
        // Make paragraph styles for attachments
        let centerParagraphStyle = NSMutableParagraphStyle()
        centerParagraphStyle.alignment = .center
        centerParagraphStyle.paragraphSpacing = 10
        centerParagraphStyle.paragraphSpacingBefore = 10

        let leftParagraphStyle = NSMutableParagraphStyle()
        leftParagraphStyle.alignment = .left
        leftParagraphStyle.paragraphSpacing = 10
        leftParagraphStyle.paragraphSpacingBefore = 10

        // Create an image view with a tap recognizer
        let imageView = UIImageView(image: UIImage(systemName: "circle"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let handler = TapHandler()
        let gestureRecognizer = UITapGestureRecognizer(target: handler, action: #selector(TapHandler.handle(_:)))
        imageView.addGestureRecognizer(gestureRecognizer)

        // Create an activity indicator view
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .black
        spinner.hidesWhenStopped = false
        NSRange()
        spinner.startAnimating()

        // Create a text field
        let textField = UITextField()
        textField.borderStyle = .roundedRect

        // Create a web view, because why not
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        webView.load(URLRequest(url: URL(string: "https://revealapp.com")!))

        // Add attachments to the string and set it on the text view
        // This example avoids evaluating the attachments or attributed strings with attachments in the Playground because Xcode crashes trying to decode attachment objects
        let richText = NSMutableAttributedString()
        
        richText.append(UITextView.testSetting().insertingAttachment(SubviewTextAttachment(view: imageView, size: CGSize(width: 256, height: 256)), at: 20, with: centerParagraphStyle))
        
        richText.append(UITextView.testSetting().insertingAttachment(SubviewTextAttachment(view: spinner), at: 0))
        
        richText.append(UITextView.testSetting().insertingAttachment(SubviewTextAttachment(view: UISwitch()), at: 10))
        return richText
    }
}
extension SecondViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer (_ gestureRecognizer: UIGestureRecognizer,
                            shouldRecognizerSimultaneouslyWithotherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension SecondViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if textView.attributedText.string == titleAttribute.string{
            self.textView.selectedRange = NSMakeRange(0, 0)
            return
        }
        
        
//        let deSelectionNSRange = contentViewModel.paragraphTrackingUtility.ranges[2]
//
//        //        textView.textRangeFromNSRange(range: contentViewModel.paragraphTrackingUtility.ranges[0])
//
//        let paragraphRange = (textView.text as NSString).paragraphRange(for: textView.selectedRange)
//        if deSelectionNSRange == paragraphRange{
//
//            self.textView.selectedRange = NSMakeRange(contentViewModel.paragraphTrackingUtility.ranges[0].location, 0)
//            return
//        }
//
//        print("paragraphRange : \(paragraphRange)")
//        guard let textRange = textView.textRangeFromNSRange(range: paragraphRange) else { return }
//        print(textView.text(in: textRange ))
        
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        // textView에서 붙여넣기(paste) 이벤트 발생시 -> URL 인지 검사
        if contentViewModel.isPasteValue == true{
            contentViewModel.onPasteValue.onNext(false)
            return isTextValidURL(text)
        }
        
        
        if text == "\n"{
            // 제목을 입력하지 않으면 "\n" 입력 -> false
            if range == NSRange(location: 0, length: 0){
                return false
            }else {
                textView.typingAttributes = [
                    NSAttributedString.Key.backgroundColor : UIColor.clear,
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
                    NSAttributedString.Key.foregroundColor : UIColor.label
                ]
                return true
            }
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



