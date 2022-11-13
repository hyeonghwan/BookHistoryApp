//
//  UITextView-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit

extension UITextView {
    func settingCusor(_ color: UIColor){
        UITextView.appearance().tintColor = color
    }
    
}

extension UITextView{
    
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
