//
//  UIFont-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/06.
//

import UIKit

public extension UIFont {

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
}
