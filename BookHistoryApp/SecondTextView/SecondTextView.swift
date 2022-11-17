//
//  SecondTextView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit
import SnapKit

class SecondTextView: UITextView {
    
    
    var scrollDelegate: SecondTextViewScrollDelegate?
    
    private let scTextStorage = SCTextStorage()
    
   
    
    override var bounds: CGRect{
        didSet{
//            self.bounds.size.height += 300
        }
    }
    override var contentOffset: CGPoint{
        didSet{
            print("self.contentOffset TextView : \(self.contentOffset)")
            
        }
    }
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        let manager: TextWrapLayoutManager = TextWrapLayoutManager()
        
        scTextStorage.addLayoutManager(manager)
        
        manager.addTextContainer(textContainer!)
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.allowsEditingTextAttributes = true
      
        self.layoutManager.delegate = self
        
        self.delegate = self
        
        self.attributedText = testSetting()
        
        // 'no replacements Found popUp menu disable' when word select
        
        self.isScrollEnabled = true
        self.alwaysBounceVertical = false
        self.isUserInteractionEnabled = true
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        
       
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        self.autocorrectionType = .no
        
        
    }
    
    convenience init(frame: CGRect,
                              textContainer: NSTextContainer?,
                              _ delegate: SecondTextViewScrollDelegate) {
        
        self.init(frame: frame, textContainer: textContainer)
        self.scrollDelegate = delegate
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
  
    
    fileprivate func insertAtTextViewCursor(attributedString: NSAttributedString) {
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
    
 
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        
        return super.selectionRects(for: range)
    }
    
 
    
}


extension SecondTextView {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var original = super.caretRect(for: position)
        
        guard let height = self.font?.lineHeight else { return original}
        
        original.size.height = height
        
        return original
    }
    
    private func scrollToCursorPositionIfBelowKeyboard() {
        let keyboardHeight: CGFloat = 295 + 44
        print("keyboardHeight", keyboardHeight)

        let caret = self.caretRect(for: self.selectedTextRange!.start)

        let keyboardTopBorder = self.bounds.size.height - keyboardHeight

        if caret.origin.y < keyboardTopBorder {

            self.scrollRectToVisible(caret, animated: true)

        }

    }
    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: false)
    }
    
    

}

extension SecondTextView: UITextViewDelegate{
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        
//
//        scrollToCursorPositionIfBelowKeyboard()
//
//        guard let scrollDelegate = self.scrollDelegate else {return}
        guard let textRange = self.selectedTextRange else {return}
        
        
//        scrollDelegate.scrollPostion(textRange)
        
    }
    
}

extension SecondTextView: NSLayoutManagerDelegate{
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
}
