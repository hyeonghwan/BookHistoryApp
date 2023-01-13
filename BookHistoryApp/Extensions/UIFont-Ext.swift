//
//  UIFont-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/06.
//

import UIKit

public extension UIFont {
    static var appleFontFamiliyName = "AppleSDGothicNeo"
    
    enum appleSDGothicNeo: String {

        case thin = "AppleSDGothicNeo-Thin"
        case light = "AppleSDGothicNeo-Light"
        case regular = "AppleSDGothicNeo-Regular"
        case medium = "AppleSDGothicNeo-Medium"
        case semiBold = "AppleSDGothicNeo-SemiBold"
        case bold = "AppleSDGothicNeo-Bold"

        public func font(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
    
    static func preferredFont(forTextStyle style: UIFont.TextStyle,familyName: String ,scaleFactor: CGFloat = 1) -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        //      let font = UIFont.preferredFont(forTextStyle: style)
        fontDescriptor.withFamily(familyName)
        let font = UIFont(descriptor: fontDescriptor, size: fontDescriptor.pointSize * scaleFactor)
        //        font.withSize(font.pointSize * scaleFactor)
        return font
    }
}
