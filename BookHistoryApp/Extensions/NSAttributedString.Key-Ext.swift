//
//  NSAttributedString.Key-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/05.
//

import UIKit


extension NSAttributedString.Key {
    static let comment = NSAttributedString.Key("comment")
    
    static let title_one = NSAttributedString.Key("Title1")
    static let title_two = NSAttributedString.Key("Title2")
    static let title_three = NSAttributedString.Key("Title3")
    
    static let placeHolderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
    
    static let placeHolderColorAttributeDic: [NSAttributedString.Key : Any] = [ .foregroundColor : placeHolderColor ]
    
    static let placeHolderColorAttribute: (NSAttributedString.Key,UIColor) =  (.foregroundColor, placeHolderColor)
//    [.foregroundColor : UIColor.lightGray,
//                 .font : UIFont.boldSystemFont(ofSize: 20),
//.presentationIntentAttributeName : titlePresentationKey]
}

extension NSAttributedString{
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
