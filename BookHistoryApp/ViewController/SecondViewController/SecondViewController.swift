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



@objc protocol NSAttachmentSettingProtocol{
    @objc func blockSubViewAttachmentHandler(_ sender: Any)
}


struct DependencyOfTextView{
    weak var colorViewModel: ColorViewModelProtocol?
    weak var contentViewModel: ContentViewModelProtocol?
    weak var accessoryViewModel: AccessoryCompositionProtocol?
    weak var photoAndFileDelegate: PhotoAndFileDelegate?
    weak var inputViewModel: InputViewModelProtocol?
    
    init(colorViewModel: ColorViewModelProtocol,
         contentViewModel: ContentViewModelProtocol,
         accessoryViewModel: AccessoryCompositionProtocol,
         photoAndFileDelegate: PhotoAndFileDelegate,
         inputViewModel: InputViewModelProtocol) {
        
        self.colorViewModel = colorViewModel
        self.contentViewModel = contentViewModel
        self.accessoryViewModel = accessoryViewModel
        self.photoAndFileDelegate = photoAndFileDelegate
        self.inputViewModel = inputViewModel
    }
}


class SecondViewController: UIViewController {
    
    let titlePresentationKey: String = "Title"
    
    
    lazy var defaultAttribute = [NSAttributedString.Key.backgroundColor : UIColor.clear,
                                 NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
                                 NSAttributedString.Key.foregroundColor : UIColor.label,
                                 .paragraphStyle : NSParagraphStyle.defaultParagraphStyle()]
    
    lazy var titleAttribute = [NSAttributedString.Key.foregroundColor : UIColor.label,
                               .paragraphStyle : NSParagraphStyle.titleParagraphStyle()]
    
    lazy var titleAttributeString = NSAttributedString(string: "제목을 입력해주세요",
                                            attributes: defaultAttribute)
    
    // KeyBoard InputViewType State ViewModel
    var inputViewModel: InputViewModelProtocol = InputViewModel()
    
    // TextView Color Type State ViewModel
    var colorViewModel: ColorViewModelProtocol = ColorViewModel()
    
    // TextView Save Content State ViewModel
    var contentViewModel: ContentViewModelProtocol = BookContentViewModel()
    
    var accessoryViewModel: AccessoryCompositionProtocol = AccessoryViewModel()
   
    
    //TextViewDependency
    lazy var dependency: DependencyOfTextView? = DependencyOfTextView(colorViewModel: self.colorViewModel,
                                                                     contentViewModel: self.contentViewModel,
                                                                     accessoryViewModel: self.accessoryViewModel,
                                                                     photoAndFileDelegate: self,
                                                                     inputViewModel: self.inputViewModel)
    
    
    weak var bookPagingViewModel: PagingType?
    
    
    var disposeBag = DisposeBag()
    
    var keyBoardDisposeBag = DisposeBag()
    
    private var keyBoardHeight: CGFloat = 0
    
    
    lazy var textMenuView: TextPropertyMenuView = {
        let menu = TextPropertyMenuView(frame:  CGRect(x: 0, y: 0,
                                                       width: UIScreen.main.bounds.size.width, height: 44),
                                        dependency: DependencyOfTextPropertyMenu(viewModel: self.inputViewModel,
                                                                                 accessoryViewModel: self.accessoryViewModel))
        
        menu.backgroundColor = .tertiarySystemBackground
        return menu
    }()
    
    
    
    lazy var textView: SecondTextView = {
        
        let paragraphTextStorage = ParagraphTextStorage()
 
        paragraphTextStorage.paragraphDelegate = contentViewModel.paragraphTrackingUtility.self
        
        let layoutManager = TextWrapLayoutManager()
        
        layoutManager.textStorage = paragraphTextStorage
        
        let customTextContainer = CustomTextContainer(size: .zero)
        
        paragraphTextStorage.addLayoutManager(layoutManager)
        
        layoutManager.addTextContainer(customTextContainer)
        
        let textView = SecondTextView(frame:.zero,
                                      textContainer: customTextContainer,
                                      dependency)
        textView.backgroundColor = .tertiarySystemBackground
        textView.delegate = self
        
        
        return textView
    }()
    
    
    deinit{
//        self.disposeBag = DisposeBag()
//        self.keyBoardDisposeBag = DisposeBag()
        print("secondViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = .tertiarySystemBackground
        
        self.view.addSubview(textView)

        self.textView.inputAccessoryView = textMenuView
        
        self.addAutoLayout()
        
        self.settingKeyBoardNotification()
        
        settingNavigation()
        
        addTextViewTitlePlaceHolder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            guard let self = self else {return}
            self.textView.contentSize.height += 500
        })
        
        settupBinding()
        
        addLongPressGesture()
    }
    
//    static func preferredFont(forTextStyle style: UIFont.TextStyle, scaleFactor: CGFloat) -> UIFont {
//      let font = UIFont.preferredFont(forTextStyle: style)
//      return font.withSize(font.pointSize * scaleFactor)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textView.inputAccessoryView = nil
        print("secondViewController : viewWillDisappear")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("secondViewController : viewDidDisappear")
    }
    

    private func settingNavigation(){
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.tintColor = .label
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
    }
    
    private func settupBinding(){
        
        // -> TextView Content Save trigger
        self.navigationItem.rightBarButtonItem?.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.contentViewModel
                    .onParagraphData
                    .onNext(self.textView.attributedText)
            }).disposed(by: disposeBag)
        
        contentViewModel
            .toTextObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owned, data in
                owned.setAttributedOnTextView_Title(data)
            })
            .disposed(by: disposeBag)
        
        contentViewModel
            .toMetaDataURL
            .subscribe(onNext: { [weak self] og in
                print(og)
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
    
    func setKeyboardHeight(_ height: CGFloat){
        self.keyBoardHeight = height
    }
    
    func getKeyboardHeight() -> CGFloat {
        return self.keyBoardHeight
    }
    
    func updateUndoButtons() {
        
        textMenuView.undoButton.isEnabled = textView.undoManager?.canUndo ?? false
        textMenuView.redoButton.isEnabled = textView.undoManager?.canRedo ?? false
    }
        
}
private extension SecondViewController{
    
    func setAttributedOnTextView_Title(_ bookData: BookViewModelData){
        guard let title = bookData.bookTitle else {return}
        guard let content = bookData.bookContent else {return}
        print("content: \(content)")
        self.setLeftAlignTitleView(font: UIFont.boldSystemFont(ofSize: 16), text: title, textColor: .label)
        self.textView.attributedText = content
    }
    
    
    func addTextViewTitlePlaceHolder() {
       
//        textView.attributedText = titleAttribute
//        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//        textView.attributedText = subAttatchViewTest()
        
    }
    

    //정규식 으로 추가해서 URL 추출이 필요함!
    func isTextValidURL(_ text: String) -> Bool{
        var urlString = text
        urlString.removeAll(where: { $0 == "\n"})
        
        guard let url = URL(string: urlString) else {return true}
        
        contentViewModel.onURLData.onNext(url)
        return true
    }
    
    @objc func handle(_ sender: UIGestureRecognizer!) {
        if let imageView = sender.view as? UIImageView {
            imageView.alpha = CGFloat(arc4random_uniform(1000)) / 1000.0
        }
    }
    
    private func subAttatchViewTest() -> NSAttributedString{
 
        // Create an image view with a tap recognizer
        let imageView = UIImageView(image: UIImage(systemName: "circle"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handle(_:)))
        imageView.addGestureRecognizer(gestureRecognizer)

        // Create an activity indicator view
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .black
        spinner.hidesWhenStopped = false
        spinner.startAnimating()

        // Create a text field
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        // Create a web view, because why not
        
        
        // Add attachments to the string and set it on the text view
        // This example avoids evaluating the attachments or attributed strings with attachments in the Playground because Xcode crashes trying to decode attachment objects
        let richText = NSMutableAttributedString()
        let width =  self.view.bounds.width - (self.textView.textContainerInset.left + self.textView.textContainerInset.right + 12)
        print(self.systemMinimumLayoutMargins)
        
        print("widht : \(width)")
        
        richText.append(UITextView.testSetting().insertingAttachment(SubViewAttachmentContiner.settingContainer(self, imageView,
                                                                                                                size: CGSize(width: width, height: 256)), at: 20))
        richText.append(
            UITextView
            .testSetting()
            .insertingAttachment(SubViewAttachmentContiner.settingContainer(self, spinner, size: nil), at: 0))
        
        richText.append(UITextView.testSetting().insertingAttachment(SubviewTextAttachment(view: UISwitch()), at: 10))
        return richText
    }
    
    
    @objc func deleteView(_ sender: UIButton){
        let deleteButton = sender
        guard let superView = deleteButton.superview else {return}
        self.textView.attachmentBehavior.removeSeletedAttachedSubview(superView)
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
        
        let paragraphRange = self.textView.getParagraphRange(textView.selectedRange)
        
        print("paragraphRange : \(paragraphRange)")
        if paragraphRange.length == 0 {
            return
        }
        
        let attribute = textView.textStorage.attribute(.foregroundColor, at: paragraphRange.location, effectiveRange: nil)
        guard let seletedForeGround = attribute as? UIColor else {return}
  
        
        if seletedForeGround == UIColor.placeHolderColor{
            self.textView.selectedRange = NSMakeRange(paragraphRange.location, 0)
        }
        
        if textView.attributedText.string == titleAttributeString.string{
            self.textView.selectedRange = NSMakeRange(0, 0)
            return
        }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing")
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldEndEditing")
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("textView : shouldChangeTextIn : \(text)")
        print("textView : shouldChangeTextIn: \(range)")
        let paragraphRange = self.textView.getParagraphRange(range)
        
        if paragraphRange.length == 0 {
            textView.typingAttributes = defaultAttribute
            return true
        }
        
        
        if let foregroundColor = textView.textStorage.attribute(.foregroundColor, at: paragraphRange.location, effectiveRange: nil) as? UIColor,
           foregroundColor == UIColor.placeHolderColor,
           let originalFont = textView.textStorage.attribute(.font, at: paragraphRange.location, effectiveRange: nil) as? UIFont{
            
            self.titleAttribute[.font] = originalFont
            
            var newRange: NSRange = NSRange(location: paragraphRange.location, length: paragraphRange.length - 1)
            
            if paragraphRange.max == textView.text.count{
                newRange = paragraphRange
            }
            

            
            textView.textStorage.beginEditing()
            textView.textStorage.replaceCharacters(in: newRange, with: "")
            textView.textStorage.endEditing()
            
            textView.textStorage.beginEditing()
            textView.textStorage.replaceCharacters(in: NSRange(location: newRange.location, length: 0),
                                                   with: NSAttributedString(string: "\(text)", attributes: titleAttribute))
            textView.textStorage.endEditing()
            
            
            self.textView.selectedRange = NSRange(location: newRange.location + 1, length: 0)
            return false
            
        }
        
        
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
                
                textView.typingAttributes = defaultAttribute
                
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
            
            textView.attributedText = titleAttributeString
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
        print("textViewDidChange :textViewDidChange")
        
//
        
        updateUndoButtons()
        
    }
}


extension SecondViewController: NSAttachmentSettingProtocol{
    @objc func blockSubViewAttachmentHandler(_ sender: Any) {
        
        let blockOFSettingVC = BlockOfSettingVC()
        
        blockOFSettingVC.modalPresentationStyle = .fullScreen
        self.present(blockOFSettingVC, animated: true)
    }
}


