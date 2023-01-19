//
//  BlockObject.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import Foundation

protocol BlockObjectType: AnyObject{}

protocol BlockElement: AnyObject{
    func editRawText(_ text: String)
    
    var children: [BlockElement]? { get }
    var decription: String { get }
}


class BlockObject: BlockObjectType{
    let blockType: BlockType?
    let object: BlockElement?
    init(blockType: BlockType,
         object: BlockElement?) {
        self.blockType = blockType
        self.object = object
    }
}


// blockObject -> ToggleBlock -> richTextElement,child(BlockElement) -> RawTextElement
