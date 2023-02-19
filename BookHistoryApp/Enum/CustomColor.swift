//
//  CustomColor.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit

extension UIColor{
    func isPlaceHolder() -> Bool{
        return self == UIColor.placeHolderColor
    }
}
enum Color: String {
    case placeHolder
    case basic
    case clear
    case red
    case blue
    case green
    case label
    case systemCyan
    case gray
    case yellow
    case brown
    case systemMint
    case systemPink
    case systemPurple
    
    static func getColor(_ uiColor: UIColor?) -> Color {
        guard let color = uiColor else {return .basic}
        switch color {
        case .placeHolderColor:
            return .placeHolder
        case .systemPurple:
            return .systemPurple
        case .systemPink:
            return .systemPink
        case .systemMint:
            return .systemMint
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .gray:
            return .gray
        case .clear:
            return .clear
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .label:
            return .basic
        case .systemCyan:
            return .systemCyan
        default:
            return .clear
        }
    }
    
    var create: UIColor {
        switch self {
        case .placeHolder:
            return UIColor.placeHolderColor
        case .basic:
            return UIColor.label
        case .systemPurple:
            return .systemPurple
        case .systemPink:
            return .systemPink
        case .systemMint:
            return .systemMint
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .gray:
            return UIColor(red: 151/255.0, green: 154/255.0, blue: 155/255.0, alpha: 0.95)
        case .clear:
            return .clear
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return UIColor(red: 77/255.0, green: 171/255.0, blue: 154/255.0, alpha: 1)
        case .label:
            return .label
        case .systemCyan:
            return .systemCyan
        }
    }
}
extension Color{
    enum Base: String{
        case placeHolder
        case basic
        case clear
        case red
        case blue
        case green
        case label
        case systemCyan
        case gray
        case yellow
        case brown
        case systemMint
        case systemPink
        case systemPurple
    }
    var base: Base {
        switch self {
        case .placeHolder:
            return .placeHolder
        case .basic:
            return .basic
        case .clear:
            return .clear
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .label:
            return .label
        case .systemCyan:
            return .systemCyan
        case .gray:
            return .gray
        case .yellow:
            return .yellow
        case .brown:
            return .brown
        case .systemMint:
            return .systemMint
        case .systemPink:
            return .systemPink
        case .systemPurple:
            return .systemPurple
        }
    }
}
extension Color: Codable{}

