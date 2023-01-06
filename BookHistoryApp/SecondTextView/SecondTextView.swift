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
import UniformTypeIdentifiers

public struct DelegateDependency{
    let attachmentBehavior: SubviewAttachingTextViewBehavior
    let textView: UITextView
}

class SecondTextView: UITextView {
    private var colorViewModel: ColorVMType?
    
    var contentViewModel: ContentVMTypeAble?
    
    private var accessoryViewModel: AccessoryCompositionProtocol?
    
    private var disposeBag = DisposeBag()
    
    public let attachmentBehavior = SubviewAttachingTextViewBehavior()
    
    lazy var dependency: DelegateDependency = DelegateDependency(attachmentBehavior: attachmentBehavior, textView: self)
    
    private lazy var layoutManagerDelegate = LayoutManagerDelegate(dependency)
    
    
    private let topInset: CGFloat = 30
    private let leftInset: CGFloat = 12
    private let bottomInset: CGFloat = 10
    private let rightInset: CGFloat = 12
    
    var contentSizeObserver: CGSize?{
        didSet{
            guard let old = oldValue else {return}
            guard let current = self.contentSizeObserver else {return}
            if old.height > current.height {
                textContentHeightFlag = true
            }
        }
    }
    
    // this property is value to determine whether increase or stay textView Content Size
    // if this value is true, contentSize value incresed when keyboard dismiss
    var textContentHeightFlag: Bool = false
    
    override var contentSize: CGSize{
        didSet{
            self.contentSizeObserver = self.contentSize
        }
    }

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
        self.layoutManager.delegate = self.layoutManagerDelegate
        self.textStorage.delegate = self.attachmentBehavior
    }
    
    convenience init(frame: CGRect,
                     textContainer: NSTextContainer?,
                     _ dependency: DependencyOfTextView) {
        
        self.init(frame: frame, textContainer: textContainer)
        
        self.colorViewModel = dependency.colorViewModel
        self.contentViewModel = dependency.contentViewModel
        self.accessoryViewModel = dependency.accessoryViewModel
        
//        self.pasteDelegate = self
        
        
        
        settUpBinding()
    }
    
    func settUpBinding(){
        colorViewModel?
            .attributedStringObservable
            .subscribe(onNext: settingTextBackGround(_:))
            .disposed(by: disposeBag)
        
        accessoryViewModel?
            .outPutActionObservable
            .bind(onNext: textViewActionHandler(_:))
            .disposed(by: disposeBag)
        
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    
    func settingTextBackGround(_ presentationType: PresentationType){
        
        self.setColorSelectedText(NSAttributedString.getAttributeColorKey(presentationType),
                                  self.getSeletedPragraphRange())
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    override func copy(_ sender: Any?) {
          

        super.copy(sender)
    }
    
    override func paste(_ sender: Any?) {
        print("paste!!!")
        
        self.contentViewModel?
            .onPasteValue
            .onNext(true)
        
        super.paste(sender)
    }
    
    
   
    
    private func setColorSelectedText(_ key: [NSAttributedString.Key : Any],
                                      _ paragraphRange: NSRange) {
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        // 빈 문자열일 경우 textStorage의 attributes 메소드를 사용하여 속성을 얻으려고 하면 치명적인 에러가 발생한다. -> 아무 속성도 없기 때문에
        // -> 그래서 분기 처리를 하여 빈 문자열일 경우에는 typingAttrxibutes에 컬러 속성을 add 한다.
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

extension SecondTextView: UITextPasteDelegate{
    
    
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting,
                                          transform item: UITextPasteItem) {
        print("item.itemProvider.self : \(item.itemProvider.self)")
        print("item : \(item)")
        
        
        
        
        if item.itemProvider.hasItemConformingToTypeIdentifier(UTType.flatRTFD.identifier) {
            
            switch checkPlain_Text(){
            case .success(let att):
                print(att.containsAttachments(in: att.range))
                item.setResult(attributedString: att)
                
            case .failure(let err):
                print(err)
                break
            }
        }
        else {
            item.setDefaultResult()
        }
    }
    
    private func checkPlain_Text() -> Result<NSAttributedString,Error>{
        let rtfdStringType = "com.apple.flat-rtfd"
        
        // Get the last copied data in the pasteboard as RTFD
        if let data = UIPasteboard.general.data(forPasteboardType: rtfdStringType) {
            do {
                print("rtfd data str = \(String(data: data, encoding: .ascii) ?? "")")
                // Convert rtfd data to attributedString
                
                let attStr = try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
                // Insert it into textview
                return .success(attStr)
            }
            catch {
                print("Couldn't convert pasted rtfd")
                return .failure(error)
            }
        }
        return .failure(PasteError.unknown)
    }
    
    
}

enum PasteError: Error{
    case unknown
}

extension SecondTextView: NSLayoutManagerDelegate{
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
}
