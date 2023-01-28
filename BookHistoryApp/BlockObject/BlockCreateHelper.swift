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
    
    func createBlock(_ type: CustomBlockType.Base,_ rawText: String?) -> BlockObject?{
        guard let rawText = rawText else {return nil}
        switch type {
        case .paragraph:
            return makeTextAndChildrenBlockValueObject(type,rawText)!
            
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
        case .textHeadSymbolList:
            return makeTextAndChildrenBlockValueObject(type,rawText)!
            
        case .numberList:
            break
        case .toggleList:
            return makeTextAndChildrenBlockValueObject(type,rawText)!
            
        case .quotation:
            break
        case .separatorLine:
            break
        case .pageLink:
            break
        case .callOut:
            break
        case .none:
            break
        }
        
        return nil
    }
    
    private func makeTextAndChildrenBlockValueObject(_ type: CustomBlockType.Base,_ text: String) -> BlockObject?{
        let raw = RawTextElement(content: text, link: nil)
        let richText = [RichTextObject(text: raw)]
        let value = TextAndChildrenBlockValueObject(richText: richText, children: nil, color: nil)
        let blockType: CustomBlockType
        
        switch type {
        case .paragraph:
            blockType = CustomBlockType.paragraph(value)
        case .textHeadSymbolList:
            blockType = CustomBlockType.textHeadSymbolList(value)
        case .toggleList:
            blockType = CustomBlockType.toggleList(value)
        default:
            return nil
        }
        
        let blockWrapping = BlockTypeWrapping(blockType)
        
        //make Block Info
        let blockInfo = makeBlockInfo(type)
        
        let blockObject = BlockObject(blockInfo: blockInfo ,
                                      object: blockWrapping,
                                      blockType: blockWrapping.e)
        return blockObject
    }
    
    private func makeBlockInfo(_ type: CustomBlockType.Base) -> BlockInfo{
        let id = EntityIdentifier_C(UUID().uuidString)
        
        let info = BlockInfo(id: id,
                             type: type,
                             archived: false,
                             createdTime: Date(),
                             lastEditedTime: Date(),
                             hasChildren: false,
                             color: "",
                             createdBy: "hwan",
                             lastEditedBy: "hwan")
        return info
        
    }
    
    
    
}
