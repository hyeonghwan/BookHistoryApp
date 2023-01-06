//
//  TextStorage.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit

import UIKit

class SCTextStorage: NSTextStorage {
    let backingStore = NSMutableAttributedString()
    private var replacements: [String: [NSAttributedString.Key: Any]] = [:]
    
    
    override var string: String {
        return backingStore.string
    }
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key: Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        print("replaceCharactersInRange:\(range) withString:\(str)")
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with:str)
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
        print("setAttributes:\(String(describing: attrs)) range:\(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    
    func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange =
        NSUnionRange(changedRange,
                     NSString(string: backingStore.string).lineRange(for: NSMakeRange(changedRange.location, 0)))
        extendedRange =
        NSUnionRange(changedRange,
                     NSString(string: backingStore.string).lineRange(for: NSMakeRange(NSMaxRange(changedRange), 0)))
        
        //Paragraph Range -> 과거의 NSRange를 표현 ) - ExtendedRange -> changedRange를 통해서 현재의 NSRange를 표현
        print("paragraphRange1: \((backingStore.string as! NSString).paragraphRange(for: changedRange))")
        print("extendedRange1 : \(extendedRange)")
        
    }
    
    override func processEditing() {
        print("editedRange : \(editedRange)")
        performReplacementsForRange(changedRange: editedRange)
        super.processEditing()
    }
  
//    Apple SD Gothic Neo
//    == AppleSDGothicNeo-Regular
//    == AppleSDGothicNeo-Thin
//    == AppleSDGothicNeo-UltraLight
//    == AppleSDGothicNeo-Light
//    == AppleSDGothicNeo-Medium
//    == AppleSDGothicNeo-SemiBold
//    == AppleSDGothicNeo-Bold
  
    
  
}
