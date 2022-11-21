//
//  CustomColor.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit

enum Color: String {
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
    
    static func getColor(_ uiColor: UIColor) -> Color {
        switch uiColor {
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
            return .label
        case .systemCyan:
            return .systemCyan
        default:
            return .clear
        }
    }
    
    
    var create: UIColor {
        
        switch self {
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
            return .label
        case .systemCyan:
            return .systemCyan
        }
    }
}
