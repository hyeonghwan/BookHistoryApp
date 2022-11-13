//
//  Attribute.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit



class CustomAttribute: NSAttributedString{}

enum TextType {
    case backGround(_ color: Color, _ font: UIFont)
}

protocol NSAttributedStringExtension {
    static func attributed(string: String, font: UIFont, color: UIColor) -> NSAttributedString
    static func attributed(string: String, font: UIFont, type: Color) -> NSAttributedString
    static func getAttributes(_ textType: TextType) -> [NSAttributedString.Key : Any]
    static func getAttributeKeys(_ textType: TextType) -> [NSAttributedString.Key]
}

extension NSAttributedString : NSAttributedStringExtension {
    
    class func attributed(string: String, font: UIFont, color: UIColor) -> NSAttributedString {
        
        let attrs = [NSAttributedString.Key.font:font,
                     NSAttributedString.Key.foregroundColor : color]
        return NSAttributedString(string: string, attributes: attrs)
    }
    
    static func attributed(string: String, font: UIFont, type: Color) -> NSAttributedString {
        let attrs: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.presentationIntentAttributeName : type,
            NSAttributedString.Key.font:font
        ]
        return NSAttributedString(string: string, attributes: attrs)
    }
    
    class func getAttributes(_ textType: TextType) -> [Key : Any] {
        switch textType{
        case let .backGround(color,font):
            return [
                NSAttributedString.Key.presentationIntentAttributeName : color,
                NSAttributedString.Key.font : font
            ]
        }
    }
    
    class func getAttributeKeys(_ textType: TextType) -> [NSAttributedString.Key] {
        
        switch textType{
        case .backGround(_,_):
            return [
                NSAttributedString.Key.presentationIntentAttributeName,
                NSAttributedString.Key.font
            ]
        }
        
    }
    
    
}
