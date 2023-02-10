//
//  SecondLayoutManager.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit

class TextWrapLayoutManager: NSLayoutManager {
    
    var font = UIFont.systemFont(ofSize: 16, weight: .bold)
    
    
//    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        
//
//        self.enumerateLineFragments(forGlyphRange: NSMakeRange(0, self.numberOfGlyphs)) { (rect, usedRect, textContainer, glyphRange, Bool) in
//
//            guard let backGroundColor =
//                    textContainer.layoutManager?.textStorage?.attribute(
//                        NSAttributedString.Key.backgroundColor,
//                        at: glyphRange.location,
//                        longestEffectiveRange: nil,
//                        in: glyphRange) as? UIColor else { return }
//
//            let lineBoundingRect = self.boundingRect(forGlyphRange: glyphRange, in: textContainer)
//            
//            var adjustedLineRect = lineBoundingRect.offsetBy(dx: origin.x , dy: origin.y )
//
//            adjustedLineRect.size.height = self.font.lineHeight
//
//            adjustedLineRect.size.width = usedRect.size.width - 10
//
//            let fillColorPath: UIBezierPath = UIBezierPath(rect: adjustedLineRect)
//            
//            backGroundColor.setFill()
//
//            fillColorPath.fill()
//        }
//    }
    
//    
//    override func drawUnderline(forGlyphRange glyphRange: NSRange,
//        underlineType underlineVal: NSUnderlineStyle,
//        baselineOffset: CGFloat,
//        lineFragmentRect lineRect: CGRect,
//        lineFragmentGlyphRange lineGlyphRange: NSRange,
//        containerOrigin: CGPoint) {
//        
//        
//        
//        var size = CGSize(width: lineRect.size.width, height: lineRect.size.height - 5)
//        var newRect = CGRect(origin: lineRect.origin, size: size)
//        
//        super.drawUnderline(forGlyphRange: glyphRange, underlineType: underlineVal, baselineOffset: baselineOffset + 10, lineFragmentRect: newRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
////        
////        let firstPosition  = location(forGlyphAt: glyphRange.location).x
////
////        let lastPosition: CGFloat
////
////        if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange) {
////            lastPosition = location(forGlyphAt: NSMaxRange(glyphRange)).x
////        } else {
////            lastPosition = lineFragmentUsedRect(
////                forGlyphAt: NSMaxRange(glyphRange) - 1,
////                effectiveRange: nil).size.width
////        }
////        
////        
////
////        var lineRect = lineRect
////        
////        // lineRect.size.height * 3.5 / 4.0 // replace your under line height
////        let height =  self.font.lineHeight
////        
////        lineRect.origin.x += firstPosition
////        lineRect.size.width = lastPosition - firstPosition
////        lineRect.size.height = height
////
////        lineRect.origin.x += containerOrigin.x
////        lineRect.origin.y += containerOrigin.y
////
////        lineRect = lineRect.integral.insetBy(dx: 0.5, dy: 0.5)
////
////        let path = UIBezierPath(rect: lineRect)
////        // let path = UIBezierPath(roundedRect: lineRect, cornerRadius: 3)
////        // set your cornerRadius
////        path.fill()
//    }
    
    
}


