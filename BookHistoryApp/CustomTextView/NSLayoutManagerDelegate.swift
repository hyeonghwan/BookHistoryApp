//
//  CustomTextView-LayoutDelegate.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit

extension CustomTextView: NSLayoutManagerDelegate{
   
    override public func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let isFont = self.font else { return superRect }


        let location = self.offset(from: self.beginningOfDocument, to: position)
        
        
        let fontLineHeight = self.font?.lineHeight ?? 0
        let lineHeight = fontLineHeight * lineHeightMultiple
        let baselineNudge = (lineHeight - fontLineHeight) * 0.6
        
        
        superRect.origin.y += baselineNudge
        
        if location >= self.textStorage.length {
            
            superRect.size.height = isFont.lineHeight + spacing
           return superRect
        }
        
        if let paragrahStyle = self.textStorage.attribute(.paragraphStyle, at: location, effectiveRange: nil) as? NSParagraphStyle {
            superRect.origin.y += paragrahStyle.paragraphSpacingBefore
        }
    
        superRect.size.height = isFont.pointSize - isFont.descender + spacing
        return superRect
    }
    
     
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        if glyphIndex == 0 {

            return spacing
        }
        return spacing * 10
    }
    
  
  
    func layoutManager(_ layoutManager: NSLayoutManager,
                       lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return spacing
    }
    

    func layoutManager(_ layoutManager: NSLayoutManager,
                       shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>,
                       baselineOffset: UnsafeMutablePointer<CGFloat>,
                       in textContainer: NSTextContainer,
                       forGlyphRange glyphRange: NSRange) -> Bool {

        
        let fontLineHeight = self.font?.lineHeight ?? 0

        let lineHeight = fontLineHeight * lineHeightMultiple
        let baselineNudge = (lineHeight - fontLineHeight)
        // The following factor is a result of experimentation:
        * 0.6

        var rect = lineFragmentRect.pointee
        rect.size.height = lineHeight

        var usedRect = lineFragmentUsedRect.pointee
        usedRect.size.height = max(lineHeight, usedRect.size.height) // keep emoji sizes

        lineFragmentRect.pointee = rect
        lineFragmentUsedRect.pointee = usedRect
        baselineOffset.pointee = baselineOffset.pointee + baselineNudge
        
        return true

    }
}
