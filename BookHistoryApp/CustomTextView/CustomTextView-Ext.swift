//
//  CustomTextView-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit

extension CustomTextView{
    
    func setBackGround(_ textRange: NSRange){
        
        self.layoutManager.enumerateLineFragments(forGlyphRange: textRange) {[weak self] (rect, usedRect, container, range, _) in

            let composeText = (container.layoutManager?.textStorage?.string ?? "") as NSString
            
            guard let self = self else { return }
            
            let paragraphRange = composeText.paragraphRange(for: range)
            
            print("range: \(range)")
            print("paragraphRange: \(paragraphRange)")
            
            guard let name = container.layoutManager?.textStorage?.attribute(NSAttributedString.Key.presentationIntentAttributeName, at: paragraphRange.location, longestEffectiveRange: nil, in: paragraphRange) as? Color else {print("name is nil"); return}
            
            self.drawBackGroundRect(color: name.create, usedRect: usedRect)
            
        }
    }
    
    
    private func drawBackGroundRect(color: UIColor, usedRect: CGRect){
        var bgRect = usedRect
        
        let fontLineHeight = self.font?.lineHeight ?? 0
        
        let lineHeight = fontLineHeight * self.lineHeightMultiple
        let baselineNudge = (lineHeight - fontLineHeight)
        // The following factor is a result of experimentation:
        * 0.6
        
        bgRect.origin.x += (self.textContainerInset.left + self.textContainer.lineFragmentPadding)
        bgRect.size.width -= (self.textContainerInset.left)
        bgRect.origin.y += (self.spacing * 2 + (baselineNudge * 2))
        bgRect.size.height -= self.spacing
        
        let bezierPath = UIBezierPath(rect: bgRect)
        
        color.setFill()
        bezierPath.fill()
        bezierPath.close()

    }
    
}
