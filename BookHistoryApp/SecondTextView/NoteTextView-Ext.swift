//
//  NoteTextView-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/04.
//

import UIKit
import RxCocoa
import RxSwift
import SubviewAttachingTextView
import SnapKit


extension SecondTextView{
    func textViewActionHandler(_ action: MenuActionType){
        switch action{
        case .blockAdd:
            break
        case .paragraphSetting:
            break
        case .blockComment:
            addBlcokComment("value")
        case .blcokimage:
            break
        case .boldItalicUnderLine:
            addBoldAttribute(self.selectedRange)
        case .blockRemove:
            break
        case .blcokSetting:
            settingBlock(self.selectedRange)
        case .blockTap:
            tapCancelBlock(self.selectedRange)
        case .blcokTapCancel:
            tapBlock(self.selectedRange)
        case .blockUp:
            blockUp(self.selectedRange)
        case .blcokDown:
            blockDown(self.selectedRange)
        case .none:
            break
        }
    }

}

extension SecondTextView{
    func blockUp(_ range: NSRange){
        let paragraphRange = self.getParagraphRange(range)
        guard let paragraphIndex = self.contentViewModel?.paragraphTrackingUtility.ranges.firstIndex(where: {$0 == paragraphRange}) else {return}
        
        
        if paragraphIndex > 1{
            guard let beforeRange = self.contentViewModel?.paragraphTrackingUtility.ranges[paragraphIndex - 1] else {return}
    
            guard let beforeString = self.contentViewModel?.paragraphTrackingUtility.paragraphs[paragraphIndex - 1] else {return}
            
            guard let beforeAttribute = self.contentViewModel?.paragraphTrackingUtility.attributes[paragraphIndex - 1] else {return}
            
            guard let paragraphRange = self.contentViewModel?.paragraphTrackingUtility.ranges[paragraphIndex] else {return}
            
            guard let paragraphString = self.contentViewModel?.paragraphTrackingUtility.paragraphs[paragraphIndex] else {return}
            
            guard let paragraphAttribute = self.contentViewModel?.paragraphTrackingUtility.attributes[paragraphIndex] else {return}
    
            self.textStorage.replaceCharacters(in: paragraphRange, with: NSAttributedString(string: "\(beforeString)", attributes: beforeAttribute))
            
            
            self.textStorage.replaceCharacters(in: beforeRange, with: NSAttributedString(string: "\(paragraphString)", attributes: paragraphAttribute))
        }
        else{
            return
        }
        
    }
    func blockDown(_ range: NSRange){
        let paragraphRange = self.getParagraphRange(range)
        guard let paragraphIndex = self.contentViewModel?.paragraphTrackingUtility.ranges.firstIndex(where: {$0 == paragraphRange}) else {return}
        
        
        if paragraphIndex > 1{
            guard let beforeRange = self.contentViewModel?.paragraphTrackingUtility.ranges[paragraphIndex - 1] else {return}
    
            guard let beforeString = self.contentViewModel?.paragraphTrackingUtility.paragraphs[paragraphIndex - 1] else {return}
            
            guard let beforeAttribute = self.contentViewModel?.paragraphTrackingUtility.attributes[paragraphIndex - 1] else {return}
            
            guard let paragraphRange = self.contentViewModel?.paragraphTrackingUtility.ranges[paragraphIndex] else {return}
            
            guard let paragraphString = self.contentViewModel?.paragraphTrackingUtility.paragraphs[paragraphIndex] else {return}
            
            guard let paragraphAttribute = self.contentViewModel?.paragraphTrackingUtility.attributes[paragraphIndex] else {return}
    
            self.textStorage.replaceCharacters(in: paragraphRange, with: NSAttributedString(string: "\(beforeString)", attributes: beforeAttribute))
            
            
            self.textStorage.replaceCharacters(in: beforeRange, with: NSAttributedString(string: "\(paragraphString)", attributes: paragraphAttribute))
        }
        else{
            return
        }
    }
}
extension SecondTextView{
    func settingBlock(_ range: NSRange){
//        let attribute = self.textStorage.attribute(.paragraphStyle, at: range.location, effectiveRange: nil)
//        print("paragraphattribute: \(attribute)")
    }
}
extension SecondTextView{
    func getParagraphRange(_ range: NSRange) -> NSRange {
        let allText: String = self.text
        let composeText: NSString = allText as NSString
        var paragraphRange = composeText.paragraphRange(for: range)
        return paragraphRange
    }
}
extension SecondTextView{
    
    func tapBlock(_ range: NSRange){
        let tapParagraphStyle = NSMutableParagraphStyle()
        tapParagraphStyle.firstLineHeadIndent = 30
        tapParagraphStyle.headIndent = 30
        
        let paragraphRange = self.getParagraphRange(range)
        guard let textRange = self.textRangeFromNSRange(range: paragraphRange) else {return}
    
        var attribute = self.textStorage.attributes(at: paragraphRange.location,
                                                    longestEffectiveRange: nil,
                                                    in: paragraphRange)
        
        attribute[.paragraphStyle] = tapParagraphStyle
        
        guard let text = self.text(in: textRange) else {return}
        
        let nsAttributedString = NSAttributedString(string: text,
                                                    attributes: attribute)
        self.textStorage.replaceCharacters(in: paragraphRange,
                                           with: nsAttributedString.string)
        self.textStorage.addAttribute(.paragraphStyle, value: tapParagraphStyle, range: paragraphRange)
    }
    func tapCancelBlock(_ range: NSRange){
        let tapParagraphStyle = NSMutableParagraphStyle()
        tapParagraphStyle.firstLineHeadIndent = 0
        tapParagraphStyle.headIndent = 0
        
        let paragraphRange = self.getParagraphRange(range)
        guard let textRange = self.textRangeFromNSRange(range: paragraphRange) else {return}
    
        var attribute = self.textStorage.attributes(at: paragraphRange.location,
                                                    longestEffectiveRange: nil,
                                                    in: paragraphRange)
        
        attribute[.paragraphStyle] = tapParagraphStyle
        
        guard let text = self.text(in: textRange) else {return}
        
        let nsAttributedString = NSAttributedString(string: text,
                                                    attributes: attribute)
        self.textStorage.replaceCharacters(in: paragraphRange,
                                           with: nsAttributedString.string)
        self.textStorage.addAttribute(.paragraphStyle, value: tapParagraphStyle, range: paragraphRange)
    }
}

extension SecondTextView{
    func addBoldAttribute(_ range: NSRange){
        self.textStorage.addAttribute(.font, value: UIFont.appleSDGothicNeo.bold.font(size: 16), range: range)
        self.typingAttributes[.font] = UIFont.appleSDGothicNeo.bold.font(size: 16)
    }
}

extension SecondTextView{
    private func addBlcokComment(_ value: String){
        let allText: String = self.text
        let composeText: NSString = allText as NSString
        var paragraphRange = composeText.paragraphRange(for: self.selectedRange)
        
        var commentView: CommentView = {
            let view = CommentView(frame: CGRect(x: 0, y: 0, width: 70, height: 18))
            return view
        }()
        
        
        self.layoutManager.enumerateLineFragments(forGlyphRange: paragraphRange, using: {[weak self] (rect, usedRect, textContainer, glyphRange, stop) in
            guard let self = self else { return }
          
            var adjustedRect = rect
            adjustedRect.origin.y += self.textContainerInset.top
            
            self.addSubview(commentView)
            commentView.frame.origin.x = adjustedRect.width - (commentView.commentImageView.frame.width) - 30
            commentView.frame.origin.y = adjustedRect.origin.y
            
            var path = commentView.frame
            path.origin.x -= self.textContainerInset.left
            path.origin.y -= self.textContainerInset.top
            
            var commentBlockPath = CommentBlockPath(path)
            guard let commentPath = commentBlockPath.commentPath else { return }
            self.textContainer.exclusionPaths.append(commentPath)
            
            self.textStorage.addAttribute(.comment, value: commentBlockPath, range: paragraphRange)
            
            self.typingAttributes[.foregroundColor] = UIColor.systemPink
            
            self.textStorage.addAttribute(.foregroundColor, value: UIColor.systemPink, range: paragraphRange)
            
            guard let textRange = self.textRangeFromNSRange(range: paragraphRange) else {return}
            
            print("self.text(in: textRange) : \(self.text(in: textRange))")
            
            stop.pointee = true
            
        })
        
    }
}

// old code to add in TextStrage by using SubviewAttachment
//print("rect : \(rect)")
//print("usedRect: \(usedRect)")
//print("glyphRange: \(glyphRange)")
//print("paragraphRange: \(paragraphRange)")
//
//

////

//        rect : (0.0, 29.09375, 351.0, 16.48)
//        usedRect : (0.0, 29.09375, 350.576, 16.480000000000004)
//        rect : (0.0, 45.573750000000004, 351.0, 16.48)
//        usedRect : (0.0, 45.573750000000004, 342.16, 16.480000000000004)
//        rect : (0.0, 62.05375000000001, 351.0, 16.48)
//        usedRect : (0.0, 62.05375000000001, 106.88000000000001, 16.480000000000004)
//
//        lineBoundingRect : (5.0, 29.09375, 340.576, 16.480000000000004)
//        adjustedLineRect : (17.0, 59.09375, 340.576, 19.09375)
//        fillColorPath : <UIBezierPath: 0x283d7fd00; <MoveTo {17, 59.09375}>,
//         <LineTo {357.57600000000002, 59.09375}>,
//         <LineTo {357.57600000000002, 78.1875}>,
//         <LineTo {17, 78.1875}>,
//         <Close>
//
//        lineBoundingRect : (5.0, 45.573750000000004, 332.16, 16.480000000000004)
//        adjustedLineRect : (17.0, 75.57375, 332.16, 19.09375)
//        fillColorPath : <UIBezierPath: 0x283d7f880; <MoveTo {17, 75.573750000000004}>,
//         <LineTo {349.16000000000003, 75.573750000000004}>,
//         <LineTo {349.16000000000003, 94.667500000000004}>,
//         <LineTo {17, 94.667500000000004}>,
//         <Close>
//
//        2.61375
//        let lineBoundingRect = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
//        print("lineBoundingRect : \(lineBoundingRect)")
//        print("rect : \(rect)")
//        print("usedRect : \(usedRect)")
//
//
//        lineBoundingRect : (5.0, 29.09375, 340.576, 16.480000000000004)
//        lineBoundingRect : (5.0, 45.573750000000004, 332.16, 16.480000000000004)
//        lineBoundingRect : (5.0, 62.05375000000001, 341.0, 16.480000000000004)
//        29 + 16 = 45.5 -> 13.52
//        62 + 13.52
//        adjustedLineRect : (17.0, 59.09375, 340.576, 19.09375)
//        adjustedLineRect : (17.0, 75.57375, 332.16, 19.09375)
//        adjustedLineRect : (17.0, 92.05375000000001, 96.88000000000001, 19.09375)


//        let currentString = self.textStorage.attributedSubstring(from: paragraphRange)
//
//        self.textStorage.replaceCharacters(in: paragraphRange,
//                                           with: NSAttributedString(string: "")
//            .insertingAttachment(SubviewTextAttachment(view: commentTextView,
//                                                       size: CGSize(width: (self.bounds.width - (self.textContainerInset.left + self.textContainerInset.right)),
//                                                                                                                                                                                 height: 50)), at: 0))
//        commentTextView.attributedText = currentString
