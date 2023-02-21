//
//  UITextView-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit

extension UITextView{
    
    func selectedSeparatedText(paragraph range: NSRange) -> String?{
        let seletedRange = self.selectedRange
        let paragraphRange = range
        let difference = paragraphRange.location - seletedRange.location
        let length = difference + (paragraphRange.length - seletedRange.length)
        
        let location = seletedRange.max
        let makeRange = NSMakeRange(location , length)
        guard var text = getTextFromRange(at: makeRange) else {return nil}
        if text.endsWith_Newline{ text.removeLast() }
        return text
    }
    
    func getTextFromRange(at range: NSRange) -> String?{
        guard let text = self.textViewElementFromNSRange(range: range) else {return nil}
        return text
    }
    
    func isLineChangeRange() -> Bool{
        return true
    }
    func isLineChangeRange(compare paragraphRange: NSRange) -> Bool{
        let lineChangeRange = NSMakeRange(self.selectedRange.location - 1, 1)
        guard let text = self.textViewElementFromNSRange(range: lineChangeRange) else {return false}
        if text.isNewLine(),
           self.selectedRange.location == paragraphRange.max{
            return true
        }else{
            return false
        }
    }
    
    func rangeFromTextRange(textRange: UITextRange) -> NSRange {
        let location:Int = self.offset(from: self.beginningOfDocument, to: textRange.start)
        let length:Int = self.offset(from: textRange.start, to: textRange.end)
        return NSMakeRange(location, length)
    }
    
    
    func getParagraphRange(_ range: NSRange) -> NSRange {
        let allText: String = self.text
        let composeText: NSString = allText as NSString
        
        let paragraphRange = composeText.paragraphRange(for: range)
        return paragraphRange
    }
    
    func getCurrentParagraphRange() -> NSRange {
        let allText: String = self.text
        let composeText: NSString = allText as NSString
        
        let paragraphRange = composeText.paragraphRange(for: self.selectedRange)
        return paragraphRange
    }
    
    
    /// seleted range 에서 newLine이 입력 되었을때, 나머지 텍스트 부분 을 구하는 함수
    /// - Returns: 나머지 text
    func getTheRestText(paragrah range: NSRange, restRange: NSRange) -> String?{
        let restRange = restRange
        if let range = self.textRangeFromNSRange(range: restRange),
           let restText = self.text(in: range){
            return restText
        }else{
            return nil
        }
    }
    
    func getTheRestRange(range: NSRange) -> NSRange{
        let currentPosition = self.selectedRange
        let paragraphRange = range
        let restLength = paragraphRange.max - currentPosition.location
        
        let restRange = NSRange(location: currentPosition.location, length: restLength)
        return restRange
    }
}

extension UITextView {
    func settingCusor(_ color: UIColor){
        UITextView.appearance().tintColor = color
    }
    
    func getTextCount() -> Int{
        return self.text.count
    }
}

extension UITextView{
    
    func textViewElementFromNSRange(range: NSRange) -> String?{
        guard let uitextRange = self.textRangeFromNSRange(range: range) else {return nil}
        guard let text = self.text(in: uitextRange) else {return nil}
        return text
    }
    
    func textRangeFromNSRange(range:NSRange) -> UITextRange?
    {
        let beginning = self.beginningOfDocument
        
        guard let start = self.position(from: beginning, offset: range.location),
              let end = self.position(from: start, offset: range.length) else { return nil}
        
        return self.textRange(from: start, to: end)
    }
    
    func removeColorForRange(theRange : NSRange) {
        print("theRange: \(theRange)")
        
        
        // textStorage index crash 방지용
        if theRange.location == self.textStorage.length {
            return
        }
        
        if self.textStorage.attribute(NSAttributedString.Key.backgroundColor,
                                      at: theRange.location,
                                      effectiveRange: nil) == nil &&
            self.textStorage.attribute(NSAttributedString.Key.paragraphStyle,
                                       at: theRange.location,
                                       effectiveRange: nil) == nil
        { print("removew return"); return }
        print("removeColorForRange")
        
        let paragraphRange = (self.text as NSString).paragraphRange(for: theRange)
        
        ColorBlockManager().allKey.forEach{
            self.textStorage.removeAttribute($0, range: paragraphRange)
        }
        
        guard let textRange = self.textRangeFromNSRange(range: paragraphRange) else { return }
        guard var textComponent = text(in: textRange) else {return}
        
        if textComponent.first == "\t"{
            textComponent.removeFirst()
        }
        
        let attString: NSAttributedString = NSAttributedString(string: textComponent)
        
        self.textStorage.replaceCharacters(in: paragraphRange, with: attString)
        
    }
    
    func addColorForRange(theRange: NSRange){
        
        
        let paragraphRange = (self.text as NSString).paragraphRange(for: theRange)
        
        guard let textRange = self.textRangeFromNSRange(range: paragraphRange) else { return }
        
        // textStorage index crash 방지용
        if theRange.location == self.textStorage.length {
            return
        }
        
        
        if self.textStorage.attribute(NSAttributedString.Key.backgroundColor,
                                      at: paragraphRange.location,
                                      effectiveRange: nil) != nil {print("add return");  return }
        
        
        guard let textComponent = text(in: textRange) else {return}
        
        
        
        let attributes = ColorBlockManager.settingColorString(UIColor.gray)
        
        
        let attString: NSAttributedString = NSAttributedString(string: "\t" + textComponent, attributes: attributes )
        
        
        self.textStorage.replaceCharacters(in: paragraphRange, with: attString)
    }
    
}
