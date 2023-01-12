//
//  NSAttributedString.Key-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/05.
//

import Foundation


extension NSAttributedString.Key {
    static let comment = NSAttributedString.Key("comment")
}
///* let 2nd tuple be an array of tuples itself */
//extension NSAttributedString {
//    func getAttributes() -> [(NSRange, [(String, AnyObject)])] {
//        var attributesOverRanges : [(NSRange, [(String, AnyObject)])] = []
//        var rng = NSRange()
//        var idx = 0
//
//        while idx < self.length {
//            let foo = self.attributes(at: idx, effectiveRange: &rng)
//            var attributes : [(String, AnyObject)] = []
//
//            for (k, v) in foo { attributes.append(k, v) }
//            attributesOverRanges.append((rng, attributes))
//
//            idx = max(idx + 1, rng.toRange()?.endIndex ?? 0)
//        }
//        return attributesOverRanges
//    }
//}
//
