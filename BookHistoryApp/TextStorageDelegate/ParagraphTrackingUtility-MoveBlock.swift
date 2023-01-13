//
//  ParagraphTrackingUtility+Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/13.
//

import ParagraphTextKit
import Foundation

extension ParagraphTrackingUtility{
    
    func exChangeBlock(_ direction: BlockDirection,_ current: NSRange){
        // replaceCharacter 호출
        // -> textStorage 종료후 (DispatchQueue.main.async)
        // -> replaceCharacter 호출
        guard let paragraphIndex = self.ranges.firstIndex(where: { $0 == current } ) else {return}
        
        switch direction{
        case .down:
            moveDownBlock(paragraphIndex, 1)
        case .up:
            moveUpBlock(paragraphIndex, -1)
        }
    }
    
    private func moveUpBlock(_ paragraphIndex: Int, _ offset: Int){
        if paragraphIndex > 1{
            let moveUpBlockIndex = paragraphIndex + offset
            
            var currentParagraphString = self.paragraphs[paragraphIndex]
            let currentAttributes = self.attributes[paragraphIndex]
            let upRange = ranges[moveUpBlockIndex]
            
            if currentParagraphString.endsWithNewline{
                currentParagraphString.removeLast()
            }
            
            let currentAttributeString = NSAttributedString(string: currentParagraphString,
                                                            attributes: currentAttributes)
            
            var upParagraphString = self.paragraphs[moveUpBlockIndex]
            let upAttributes = self.attributes[moveUpBlockIndex]
            let currentRange = ranges[paragraphIndex]
            
            
            if upParagraphString.endsWithNewline{
                upParagraphString.removeLast()
            }
            
            var newCurrentRange: NSRange = NSRange(location: currentRange.location, length: currentRange.length - 1)
            let newUpRange: NSRange = NSRange(location: upRange.location, length: upRange.length - 1)
            
            if paragraphIndex == ranges.count - 1{
                newCurrentRange = NSRange(location: currentRange.location, length: currentRange.length)
            }
            
            let upAttributeString = NSAttributedString(string: upParagraphString,
                                                       attributes: upAttributes)
            
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.replaceCharacters(in: newCurrentRange, with: upAttributeString)
            self.paragraphStorage?.endEditing()
            
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.replaceCharacters(in: newUpRange, with: currentAttributeString)
            self.paragraphStorage?.endEditing()
            
            let caretPositionRange = self.ranges[moveUpBlockIndex]
            self.subAttachMentBehavior?.textView?.selectedRange = NSRange(location: caretPositionRange.max - 1, length: 0)
            
        }else {
            return
        }
    }
    
    private func moveDownBlock(_ paragraphIndex: Int,_ offset: Int){
        if paragraphIndex < ranges.count - 1{
            let moveDownBlockIndex = paragraphIndex + offset
            
            var currentParagraphString = self.paragraphs[paragraphIndex]
            
            if currentParagraphString.endsWithNewline{
                currentParagraphString.removeLast()
            }
            
            let currentAttributes = self.attributes[paragraphIndex]
            let downRange = ranges[moveDownBlockIndex]
            
            let currentAttributeString = NSAttributedString(string: currentParagraphString,
                                                            attributes: currentAttributes)
            
            var downParagraphString = self.paragraphs[moveDownBlockIndex]
            let downAttributes = self.attributes[moveDownBlockIndex]
            let currentRange = ranges[paragraphIndex]
            
            
            if downParagraphString.endsWithNewline{
                downParagraphString.removeLast()
            }
        
            var newCurrentRange: NSRange = NSRange(location: currentRange.location, length: currentRange.length - 1)
            var newdownRange: NSRange = NSRange(location: downRange.location, length: downRange.length - 1)
            
            if paragraphIndex == ranges.count - 2{
                newCurrentRange = NSRange(location: currentRange.location, length: currentRange.length - 1)
                newdownRange = NSRange(location: downRange.location, length: downRange.length )
            }
            
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.replaceCharacters(in: newdownRange ,
                                              with: currentAttributeString)
            self.paragraphStorage?.endEditing()
        
          
            let downAttributeString = NSAttributedString(string: downParagraphString,
                                                         attributes: downAttributes)
         
            self.paragraphStorage?.beginEditing()
            
            self.paragraphStorage?.replaceCharacters(in: newCurrentRange,
                                              with: downAttributeString)
            self.paragraphStorage?.endEditing()
            
            let caretPositionRange = self.ranges[moveDownBlockIndex]
            self.subAttachMentBehavior?.textView?.selectedRange = NSRange(location: caretPositionRange.max - 1, length: 0)
            
            print("self.paragraph: \(self.paragraphs)")

        }else {
            return
        }
    }
    
}

