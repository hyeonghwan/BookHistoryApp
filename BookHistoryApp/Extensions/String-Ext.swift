//
//  String-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import Foundation

extension Character{
    
    func isAttachment() -> Bool{
        return self == "\u{fffc}"
    }
}
extension String {
    
    var endsWith_Newline: Bool {
        !(last == nil || last?.isNewline == false)
    }
    
    func isBackSpaceKey() -> Bool{
        let char = self.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(char, "\u{8}"))
        if isBackSpace == -8{
            return true
        }
        return false
    }
    
    func isNewLine() -> Bool{
        return self == "\n"
    }
    
    static func newLineString() -> String{
        return "\n"
    }
    
    static func emptyStr() -> String{
        return ""
    }

    func removingAllWhitespaces() -> String {
        return removingCharacters(from: .whitespaces)
    }
    func isAttachmentSymbol() -> Bool{
        if self == "\u{fffc}"{
            return true
        }else{
            return false
        }
    }
    
    static var attachmentSymbol: String{
        return "\u{fffc}"
    }
    
    mutating func removeLastIfEnter() -> Bool {
        
        if let newLine = self.last,
           newLine == "\n"{
            self.removeLast()
            return true
        }
        
        return false
    }

    func removingCharacters(from set: CharacterSet) -> String {
        var newString = self
        newString.removeAll { char -> Bool in
            guard let scalar = char.unicodeScalars.first else { return false }
            return set.contains(scalar)
        }
        return newString
    }
}
