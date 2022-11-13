//
//  CustomColor.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit

enum Color: String {
    case red
    case blue
    case green
    case label
    case systemCyan
    

    var create: UIColor {
        switch self {
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
