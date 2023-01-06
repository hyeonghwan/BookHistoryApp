//
//  MenuActionHandler.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/03.
//

import Foundation

protocol AccessoryButtonActionProtocol {
    func action(_ type: MenuActionType)
}

enum MenuActionType {
    case blockAdd
    case paragraphSetting
    case blockComment
    case blcokimage
    case boldItalicUnderLine
    case blockRemove
    case blcokSetting
    case blockTap
    case blcokTapCancel
    case blockUp
    case blcokDown
    case none
}

extension MenuActionType {
    init(_ type: Self){
        self = type
    }
}

//final class AccessoryActionHandler:NSObject, AccessoryButtonActionProtocol{
//    
//    override init() {
//        super.init()
//    }
//    
//    func action(_ type: MenuActionType) {
//        switch type{
//        case .comment:
//            break
//        case .image:
//            break
//        case .none:
//            break
//        }
//    }
//}
