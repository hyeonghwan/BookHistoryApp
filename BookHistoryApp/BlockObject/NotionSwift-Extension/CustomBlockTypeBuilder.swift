//
//  CustomBlockTypeBuilder.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/25.
//

import UIKit


class BlockTypeBuilder{
    
    var attributesArray: [[NSAttributedString.Key : Any]] = []
    var blockValueType: BlockValueType?
    var type: CustomBlockType.Base?
    var defaultAttribute: [NSAttributedString.Key : Any] = [:]
    var attributedString: NSAttributedString?
   
    @discardableResult
    func getBlockBaseType(type: CustomBlockType.Base) -> Self{
        self.type = type
        return self
    }
    
    func getBlockValueType(block: CustomBlockType) throws -> Self{
        switch block{
        case .paragraph(let value):
            self.blockValueType = value
        case .todoList(let value):
            self.blockValueType = value
        case .title1(let value):
            self.blockValueType = value
        case .title2(let value):
            self.blockValueType = value
        case .title3(let value):
            self.blockValueType = value
        case .textHeadSymbolList(let value):
            self.blockValueType = value
        case .toggleList(let value):
            self.blockValueType = value
        default:
            throw BlockError.blockValueNilError
        }
        return self
    }
    
    func buildObject() -> BlockValueType?{
        return self.blockValueType
    }
    
    func getDefaultAttributes() -> Self{
        guard let type = self.type else {return self}
        self.defaultAttribute = NSAttributedString.getCustomBlockTypeAttributes(block: type)
        return self
    }
    
    func buildAttributes() throws -> Self{
        
        guard let object = blockValueType else { throw BlockError.blockValueNilError }
        
        var attributes: [[NSAttributedString.Key : Any]] = []
        
        object.richText.forEach{ value in
            
            var attribute: [NSAttributedString.Key : Any]  = self.defaultAttribute
            
            let annotations = value.annotations
//            let color = "label" //annotations.color.create
            
            var font : UIFont = attribute[.font] as? UIFont ?? UIFont.appleSDGothicNeo.regular.font(size: 16)
            if annotations.underline == true{
                //append
            }
            if annotations.strikethrough == true{
                //append
            }
            
            if annotations.italic == true && annotations.bold == true {
                font = font.setBoldItalic()
            }else{
                if annotations.italic == true{
                    font = font.setItalic()
                }
                if annotations.bold == true{
                    font = font.setBold()
                }
            }
            attribute[.font] = font
            if let base = Color.Base(rawValue: annotations.color),
            let color = Color(rawValue: base.rawValue)?.create{
                attribute[.foregroundColor] = color
            }
            
            attributes.append(attribute)
        }
        
        self.attributesArray = attributes
        return self
    }
    
    func build() -> [[NSAttributedString.Key : Any]]{
        return self.attributesArray
    }
    
    
}
