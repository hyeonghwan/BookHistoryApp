//
//  SecondTextView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit

class SecondTextView: UITextView {
    
    
    
    let scTextStorage = SCTextStorage()
    
    
    override init(frame: CGRect, textContainer: NSTextContainer? ) {
        
        let manager: TextWrapLayoutManager = TextWrapLayoutManager()
        
        scTextStorage.addLayoutManager(manager)
        
        manager.addTextContainer(textContainer!)
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.allowsEditingTextAttributes = true
      
        self.layoutManager.delegate = self
        
        self.delegate = self
        
        self.attributedText = testSetting()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
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
}

extension SecondTextView: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        

        return true
    }
    
}

extension SecondTextView: NSLayoutManagerDelegate{
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
}
