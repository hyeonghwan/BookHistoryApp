//
//  SecondTextView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ParagraphTextKit
import SubviewAttachingTextView



class SecondTextView: UITextView {
    
    private var colorViewModel: ColorVMType?
    
    private var contentViewModel: ContentVMBooMarkAble?
    
    private var disposeBag = DisposeBag()
    
    let attachmentBehavior = SubviewAttachingTextViewBehavior()
    
    
    private let topInset: CGFloat = 30
    private let leftInset: CGFloat = 12
    private let bottomInset: CGFloat = 10
    private let rightInset: CGFloat = 12
    

    open override var textContainerInset: UIEdgeInsets {
        didSet {
            // Text container insets are used to convert coordinates between the text container and text view, so a change to these insets must trigger a layout update
            self.attachmentBehavior.layoutAttachedSubviews()
        }
    }
 
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        settingConfiguration()
        self.commonInit()
        
    }
    
    private func commonInit() {
        // Connect the attachment behavior
        self.attachmentBehavior.textView = self
        self.layoutManager.delegate = self.attachmentBehavior
        self.textStorage.delegate = self.attachmentBehavior
    }
    
    convenience init(frame: CGRect,
                     textContainer: NSTextContainer?,
                     _ viewModel: ColorVMType,
                     _ contentVM: ContentVMBooMarkAble) {
        
        self.init(frame: frame, textContainer: textContainer)
        
        self.colorViewModel = viewModel
        self.contentViewModel = contentVM
        
        colorViewModel?
            .attributedStringObservable
            .subscribe(onNext: settingTextBackGround(_:))
            .disposed(by: disposeBag)
        
        print("self.textContainerInset: \(self.textContainerInset)")
    }
    
    fileprivate func settingConfiguration() {
        self.allowsEditingTextAttributes = true
        self.isUserInteractionEnabled = true
        self.textContainerInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        self.autocorrectionType = .no
    }
    
    
    func isLongPressGestureEnable(_ isEanableLongPress: Bool){
        guard let gestures = self.gestureRecognizers else {return}
        
        for gesture in gestures{
            if gesture.isKind(of: UILongPressGestureRecognizer.self){
                gesture.isEnabled = isEanableLongPress
            }
        }
    }
    
    
    func settingTextBackGround(_ presentationType: PresentationType){
        
        self.setColorSelectedText(NSAttributedString.getAttributeColorKey(presentationType),
                                  self.getSeletedPragraphRange())
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    override func paste(_ sender: Any?) {
        print("paste!!!")
        
        self.contentViewModel?
            .onPasteValue
            .onNext(true)
        
        super.paste(sender)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return super.canPerformAction(action, withSender: sender)
    }
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        print("touches: \(touches)")
        super.touchesEstimatedPropertiesUpdated(touches)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        print(event)
        super.touchesBegan(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled")
        super.touchesCancelled(touches, with: event)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("pressesBegan")
        super.pressesBegan(presses, with: event)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionBegan")
        super.motionBegan(motion, with: event)
    }
    
    
    private func setColorSelectedText(_ key: [NSAttributedString.Key : Any],
                                      _ paragraphRange: NSRange) {
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        // 빈 문자열일 경우 textStorage의 attributes 메소드를 사용하여 속성을 얻으려고 하면 치명적인 에러가 발생한다. -> 아무 속성도 없기 때문에
        // -> 그래서 분기 처리를 하여 빈 문자열일 경우에는 typingAttributes에 컬러 속성을 add 한다.
        if paragraphRange.length == 0 {
            
            attributes = self.typingAttributes
            
            self.typingAttributes[key.keys.first!] = key.values.first!
            
            registerUndo(attributes, paragraphRange)
            
        }else {
            attributes = self.textStorage.attributes(at: paragraphRange.location,
                                                     longestEffectiveRange: nil,
                                                     in: paragraphRange)
            registerUndo(attributes, paragraphRange)
        }
        self.textStorage.addAttributes(key, range: paragraphRange)
    }
    
    
    func insertAtTextViewCursor(attributedString: NSAttributedString) {
        // Exit if no selected text range
        guard let selectedRange = self.selectedTextRange else {
            return
        }
        
        // If here, insert <attributedString> at cursor
        let cursorIndex = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
        let mutableAttributedText = NSMutableAttributedString(attributedString: self.attributedText)
        mutableAttributedText.insert(attributedString, at: cursorIndex)
        self.attributedText = mutableAttributedText
    }
    
}


extension SecondTextView {
    
    
    /// undoAction make function
    /// - Parameters:
    ///   - attributes: specific range textStorage attributes
    ///   - paragraphRange: NSRange from paragraph
    private func registerUndo(_ attributes: [NSAttributedString.Key : Any],_ paragraphRange: NSRange) {

            undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
                targetSelf.setColorSelectedText(attributes,
                                                paragraphRange)
            })
            // UndoButton redoButton isEnable
            self.colorViewModel?.onUndoActivity.onNext(())
    }
    
    private func getSeletedPragraphRange() -> NSRange {
        let seletedNSRange = self.selectedRange
        
        let nsString = self.text as NSString
        
        let paragraphRange = nsString.paragraphRange(for: seletedNSRange)
        
        return paragraphRange
    }
    
    
//    override func caretRect(for position: UITextPosition) -> CGRect {
//        var original = super.caretRect(for: position)
//        
//        guard let height = self.font?.lineHeight else { return original}
//        
//        original.size.height = height
//        
//        return original
//    }
    
}

extension SecondTextView: NSLayoutManagerDelegate{
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
}
