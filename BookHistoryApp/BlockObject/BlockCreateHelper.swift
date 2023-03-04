//
//  BlockHelper.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import UIKit


typealias SeparatedNSAttributes_Strings = ([[NSAttributedString.Key : Any]], [String])

class BlockCreateHelper{
    
    static let shared = BlockCreateHelper()
    
    private init(){
        
    }
    
    func createBlock_to_array(_ separted: SeparatedNSAttributedString) -> BlockObject?{
        //        guard let rawText = rawText else {return nil}
        let att = separted.0
        let rawTexts = separted.1
        let type = separted.2
        
        let separated: SeparatedNSAttributes_Strings = (att, rawTexts)
        
        
        print("separated : \(separated)")
        switch type {
        case .paragraph,.textHeadSymbolList,.toggleList:
            return makeTextAndChildrenBlockValueObject(type,separated)!
        case .page:
            break
        case .todoList:
            return makeTodoBlockValueObject(block: type, tuple: separated)
        case .title1,.title2,.title3:
            return makeHedingBlockValueObject(type,separated)
        case .graph:
            break
        case .numberList:
            break
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
    
    func makeAnnotations(_ att: [NSAttributedString.Key : Any]) -> Anotations {
        
        var underline: Bool = false
        var strike: Bool = false
        var bold: Bool = false
        var italic: Bool = false
        var code: Bool = false
        var color: Color.Base = .basic
        
        if let uiColor = att[.foregroundColor] as? UIColor{
            color = Color.getColor(uiColor).base
        }
        
        if let _ = att[.underlineStyle] as? NSUnderlineStyle{
            underline = true
        }
        if let _ = att[.strikethroughStyle] as? NSUnderlineStyle{
            strike = true
        }
        
        let font = att[.font] as? UIFont
        if let fontTraits = font?.fontDescriptor.symbolicTraits{
            if fontTraits.contains(.traitItalic){
                italic = true
            }
            
            if fontTraits.contains(.traitBold){
                bold = true
            }
            
        }
        
        return Anotations(bold: bold,
                          italic: italic,
                          strikethrough: strike,
                          underline: underline,
                          code: code,
                          color: color.rawValue)
    }
    
    private func makeHedingBlockValueObject(_ type: CustomBlockType.Base,
                                            _ separted : SeparatedNSAttributes_Strings) -> BlockObject?{
        let att_s = separted.0
        let str_s = separted.1
        
        let richTextObjects
        =
        str_s
            .map{ value in RawTextElement(content: value , link: nil)}
            .enumerated()
            .map{ index, element in
                let att = att_s[index]
                let anotations = makeAnnotations(att)
                return RichTextObject(text: element, element.content!, annotations: anotations)
            }
        
        let value = HeadingBlockValueObject(richText: richTextObjects, color: Color.label.rawValue)
        
        let blockType: CustomBlockType
        
        switch type {
        case .title1:
            blockType = CustomBlockType.title1(value)
        case .title2:
            blockType = CustomBlockType.title2(value)
        case .title3:
            blockType = CustomBlockType.title3(value)
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
    
    private func makeTodoBlockValueObject(block type: CustomBlockType.Base,
                                          tuple separted: SeparatedNSAttributes_Strings) -> BlockObject? {
        let att_s = separted.0
        let str_s = separted.1
        
        let richTextObjects
        =
        str_s
            .map{ value in RawTextElement(content: value , link: nil)}
            .enumerated()
            .map{ index, element in
                let att = att_s[index]
                let anotations = makeAnnotations(att)
                return RichTextObject(text: element, element.content!, annotations: anotations)
            }
        
        let value = ToDoBlockValueObject(richText: richTextObjects, checked: false, color: nil, children: nil)
        
        let blockType: CustomBlockType
        
        switch type {
        case .todoList:
            blockType = CustomBlockType.todoList(value)
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

    private func makeTextAndChildrenBlockValueObject(_ type: CustomBlockType.Base,
                                                     _ sepatedTuple: SeparatedNSAttributes_Strings) -> BlockObject?{
        
        let att_s = sepatedTuple.0
        let str_s = sepatedTuple.1
        
        let richTextObjects
        =
        str_s
            .map{ value in RawTextElement(content: value , link: nil)}
            .enumerated()
            .map{ index, element in
                let att = att_s[index]
                let anotations = makeAnnotations(att)
                return RichTextObject(text: element, element.content!, annotations: anotations)
            }
        
        let value = TextAndChildrenBlockValueObject(richText: richTextObjects, children: nil, color: Color.label.rawValue)
        
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
