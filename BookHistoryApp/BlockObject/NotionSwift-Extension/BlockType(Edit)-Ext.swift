//
//  BlockType(Edit)-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/25.
//

import UIKit


extension CustomBlockType {
    
    func editAttributes(_ attributes: [[NSAttributedString.Key : Any]]){
        switch self {
        case .title1(let headingBlockObject):
            changeObjectAnnotaionValue(attributes, headingBlockObject)
            
        case .title2(let headingBlockObject):
            changeObjectAnnotaionValue(attributes, headingBlockObject)
            
        case .title3(let headingBlockObject):
            changeObjectAnnotaionValue(attributes, headingBlockObject)
            
        case .todoList(let todoBlockObject):
            changeObjectAnnotaionValue(attributes, todoBlockObject)
            
        case .paragraph(let textAndChildrenBlockValueObject):
            changeObjectAnnotaionValue(attributes, textAndChildrenBlockValueObject)
            
        case .textHeadSymbolList(let textAndChildrenBlockValueObject):
            changeObjectAnnotaionValue(attributes, textAndChildrenBlockValueObject)
            
        case .toggleList(let textAndChildrenBlockValueObject):
            changeObjectAnnotaionValue(attributes, textAndChildrenBlockValueObject)
            
        default:
            break
        }
    }
    func editElement(_ str: [String], _ attributes: [[NSAttributedString.Key : Any]]){
        
        switch self {
        case .title1(let headingBlockValueObject):
            changeHeadingElementValue(str, attributes ,headingBlockValueObject)
            
        case .title2(let headingBlockValueObject):
            changeHeadingElementValue(str, attributes ,headingBlockValueObject)
            
        case .title3(let headingBlockValueObject):
            changeHeadingElementValue(str, attributes ,headingBlockValueObject)
            
        case .todoList(let todoBlockObject):
            changeTodoElementValue(str, attributes, todoBlockObject)
            
        case .paragraph(let textAndChildrenBlockValueObject):
            changeTextElementValue(str, attributes ,textAndChildrenBlockValueObject)
            
        case .textHeadSymbolList(let textAndChildrenBlockValueObject):
            changeTextElementValue(str, attributes ,textAndChildrenBlockValueObject)
            
        case .toggleList(let textAndChildrenBlockValueObject):
            changeTextElementValue(str, attributes ,textAndChildrenBlockValueObject)
            
        default:
            break
        }
    }
    
    private func changeTodoElementValue(_ str: [String],
                                        _ attributes: [[NSAttributedString.Key : Any]],
                                        _ object: ToDoBlockValueObject){
        
        if object.richText.count == str.count{
            
            object.richText
            =
            object
                .richText
                .enumerated()
                .map{ index , value in
                    if str[index] == value.plain_text{
                        return value
                    }else{
                        value.text.content = str[index]
                        value.plain_text = str[index]
                        return value
                    }
                }
        }else{
            let anotations = getAnnotations(attributes)
            object.richText
            =
            str
                .enumerated()
                .map{ index,string in
                    let raw = RawTextElement(content: string, link: nil)
                    return RichTextObject(text: raw, string, annotations: anotations[index])
                }
        }
    }
    
    
    private func changeHeadingElementValue(_ str: [String],
                                           _ attributes: [[NSAttributedString.Key : Any]],
                                           _ object: HeadingBlockValueObject){
        
        if object.richText.count == str.count{
            
            object.richText
            =
            object
                .richText
                .enumerated()
                .map{ index , value in
                    if str[index] == value.plain_text{
                        return value
                    }else{
                        value.text.content = str[index]
                        value.plain_text = str[index]
                        return value
                    }
                }
        }else{
            let anotations = getAnnotations(attributes)
            object.richText
            =
            str
                .enumerated()
                .map{ index,string in
                    let raw = RawTextElement(content: string, link: nil)
                    return RichTextObject(text: raw, string, annotations: anotations[index])
                }
        }
    }
    
    private func changeTextElementValue(_ str: [String],
                                        _ attributes: [[NSAttributedString.Key : Any]],
                                        _ object: TextAndChildrenBlockValueObject){
        
        if object.richText.count == str.count{
            
            object.richText
            =
            object
                .richText
                .enumerated()
                .map{ index , value in
                    if str[index] == value.plain_text{
                        return value
                    }else{
                        value.text.content = str[index]
                        value.plain_text = str[index]
                        return value
                    }
                }
        }else{
            let anotations = getAnnotations(attributes)
            object.richText
            =
            str
                .enumerated()
                .map{ index,string in
                    let raw = RawTextElement(content: string, link: nil)
                    return RichTextObject(text: raw, string, annotations: anotations[index])
                }
        }
    }
    
    
    /// changeObject Annotations
    /// - Parameters:
    ///   - attributes: attributes about object
    ///   - object: about cofigure Object
    ///   this func is occur when user change text Attributes
    ///    editAttributes -> changeObjectAnnotaionValue
    private func changeObjectAnnotaionValue(_ attributes: [[NSAttributedString.Key : Any]],
                                            _ object: BlockValueType){
        let annotations = getAnnotations(attributes)
        
        object.richText
        =
        object
            .richText
            .enumerated()
            .map{ index , value in
                if annotations[index] == value.annotations{
                    return value
                }else{
                    value.annotations = annotations[index]
                    return value
                }
            }
    }
    
    private func getAnnotations(_ attributes: [[NSAttributedString.Key : Any]]) -> [Anotations] {
        let annotations = attributes.map{ value in
            var bold: Bool = false
            var italic: Bool = false
            if let font = value[.font] as? UIFont{
                let traits = font.fontDescriptor.symbolicTraits
                if traits.contains(.traitBold) {
                    bold = true
                }
                if traits.contains(.traitItalic){
                    italic = true
                }
            }
            let loadedColor = value[.foregroundColor] as? UIColor
            let strike = value[.strikethroughStyle] as? NSUnderlineStyle
            let underline = value[.underlineStyle] as? NSUnderlineStyle
            
            let color = Color.getColor(loadedColor).base
            
            let annotation = Anotations(bold: bold,
                                        italic: italic,
                                        strikethrough: strike,
                                        underline: underline,
                                        code: nil,
                                        color: color.rawValue)
            return annotation
        }
        return annotations
    }
}
