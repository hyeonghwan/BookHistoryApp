//
//  Attribute.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit


enum TextType {
    case backGround(_ color: Color, _ font: UIFont)
}

enum PresentationType {
    case foreGround(_ color: Color)
    case backGround(_ color: Color)
    
    
}
extension PresentationType{
    
    func getColor() -> Color{
        switch self{
        case let .backGround(color):
            return color
        case let .foreGround(color):
            return color
        }
    }

    static func getForeGroundColor(_ colors : [Color]) -> [PresentationType]{
        return colors.map{ color in PresentationType.foreGround(color) }
    }
    static func getBackGroundColor(_ colors : [Color]) -> [PresentationType]{
        return colors.map{ color in PresentationType.backGround(color) }
    }
}

protocol NSAttributedStringExtension {
    static func getAttributeColorKey(_ presentationType: PresentationType ) -> [NSAttributedString.Key : Any]
    
    static func attributed(string: String, font: UIFont, color: UIColor) -> NSAttributedString
    
    static func attributed(string: String, font: UIFont, type: Color) -> NSAttributedString
    
    static func getAttributes(_ textType: TextType) -> [NSAttributedString.Key : Any]
    
    static func getAttributeKeys(_ textType: TextType) -> [NSAttributedString.Key]
}

extension NSAttributedString : NSAttributedStringExtension {
    
    class func getAttributeColorKey(_ presentationType: PresentationType ) -> [Key : Any] {
        switch presentationType {
        case let .backGround(color):
            return [NSAttributedString.Key.backgroundColor : color.create]
        case let .foreGround(color):
            return [NSAttributedString.Key.foregroundColor : color.create]
            
        }
    }
    
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

