//
//  BlockObject.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import Foundation
import NotionSwift



protocol BlockObjectType: AnyObject{
//    var block: Block {get set}
}



protocol BlockElement: AnyObject{
    func editRawText(_ text: String)
    var richText: RichTextElement? {get set}
    var children: [BlockObject]? { get set }
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
