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

class SecondTextView: SubviewAttachingTextView {
    
    private var colorViewModel: ColorVMType?
    
    private var contentViewModel: ContentVMBooMarkAble?
    
    private var disposeBag = DisposeBag()
    

    
 
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        settingConfiguration()
        
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
    }
    
    
    func isLongPressGestureEnable(_ isEanableLongPress: Bool){
        guard let gestures = self.gestureRecognizers else {return}
        for gesture in gestures{
            if gesture.isKind(of: UILongPressGestureRecognizer.self),
               gesture.name == "PressParaGraphBlock"{
                gesture.isEnabled = isEanableLongPress
                print("gesture.isEnabled : \(isEanableLongPress)")
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
        
        let attributes = self.textStorage.attributes(at: paragraphRange.location,
                                                     longestEffectiveRange: nil,
                                                     in: paragraphRange)
        
        registerUndo(attributes, paragraphRange)
        
        self.textStorage.addAttributes(key, range: paragraphRange)
    }

    
    fileprivate func settingConfiguration() {
        self.allowsEditingTextAttributes = true
        
        self.isScrollEnabled = true
        self.alwaysBounceVertical = false
        self.isUserInteractionEnabled = true
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        
        self.contentInset = UIEdgeInsets(top: 30, left: 12, bottom: 10, right: 12)
        
        self.autocorrectionType = .no
        
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
