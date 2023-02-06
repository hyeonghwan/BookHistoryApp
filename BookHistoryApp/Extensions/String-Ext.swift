//
//  String-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import Foundation

extension String {
    
    static func emptyStr() -> String{
        return ""
    }

    func removingAllWhitespaces() -> String {
        return removingCharacters(from: .whitespaces)
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
