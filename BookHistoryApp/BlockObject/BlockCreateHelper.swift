//
//  BlockHelper.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import UIKit


class BlockCreateHelper{
    
    static let shared = BlockCreateHelper()
    
    private init(){
        
    }
    
    func createBlock(_ type: BlockType,_ rawText: String?) -> BlockObject?{
        guard let rawText = rawText else {return nil}
        switch type {
        case .paragraph:
            let richTextElement = RichTextElement(text: RawTextElement(content: "\(rawText)", link: nil))
            let paragraphBlock = ParagraphBlock(richText: richTextElement)
            let object = BlockObject(blockType: type, object: paragraphBlock)
            return object
        case .page:
            break
        case .todoList:
            break
        case .title1:
            break
        case .title2:
            break
        case .title3:
            break
        case .graph:
            break
        case .textSymbolList:
            break
        case .numberList:
            break
        case .toggleList:
            let richTextElement = RichTextElement(text: RawTextElement(content: "\(rawText)", link: nil))
            let paragraphBlock = ToggleBlock(richText: richTextElement)
            let object = BlockObject(blockType: type, object: paragraphBlock)
            return object
        case .quotation:
            break
        case .separatorLine:
            break
        case .pageLink:
            break
        case .collOut:
            break
        case .none:
            break
        }
        
        return nil
    }
    
    
    
}
