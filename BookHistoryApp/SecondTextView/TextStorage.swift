//
//  TextStorage.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit

class SCTextStorage: NSTextStorage{
    
    private let container = NSTextStorage()
    
    var contentControlBolock: [NSAttributedString] = []
    
    override var string: String {
        
        return container.string
    }
    
    func getBolock() {
        let nsString = self.string as NSString
        
    }
    
    
    
    override func insert(_ attrString: NSAttributedString, at loc: Int) {
        super.insert(attrString, at: loc)
        
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return container.attributes(at: location, effectiveRange: range)
    }
    
    
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        container.replaceCharacters(in: range, with: str)
        edited([.editedAttributes, .editedCharacters], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        container.setAttributes(attrs, range: range)
        edited([.editedAttributes], range: range, changeInLength: 0)
        endEditing()
    }
    
    
    
    override func processEditing() {
        super.processEditing()
        
    }
}
