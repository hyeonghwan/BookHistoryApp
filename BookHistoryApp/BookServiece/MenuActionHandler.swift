//
//  MenuActionHandler.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/03.
//

import UIKit
import RxSwift

protocol AccessoryButtonActionProtocol {
    func action(_ type: MenuActionType)
}
enum ImageAction {
    case photoLibrary(UIAction)
    case takePhoto(UIAction)
    case file(UIAction)
}

typealias ImageActions = [ImageAction]

enum MenuActionType {
    case blockAdd
    case paragraphSetting
    case blockComment
    case blcokimage(ContextMenuEventType)
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

struct MenuButtonType{
    let type: MenuActionType?
    let image: String?
    weak var disposeBag: DisposeBag?
    weak var viewModel: AccessoryCompositinalProtocol?
    var frame: CGRect?
    weak var color: UIColor?
    
    init(type: MenuActionType,
         image: String,
         disposeBag: DisposeBag,
         viewModel: AccessoryCompositinalProtocol,
         _ frame: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30),
         _ color: UIColor = UIColor.lightGray) {
        
        
        self.type = type
        self.image = image
        self.disposeBag = disposeBag
        self.viewModel = viewModel
        self.frame = frame
        self.color = color
    }
}
