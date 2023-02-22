//
//  CustomBlockType.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/27.
//

import UIKit

enum CustomBlockType{
    case paragraph(TextAndChildrenBlockValueObject)
    case page(ChildPageBlockValueObject)
    case todoList(ToDoBlockValueObject)
    case title1(HeadingBlockValueObject)
    case title2(HeadingBlockValueObject)
    case title3(HeadingBlockValueObject)
    case graph
    case textHeadSymbolList(TextAndChildrenBlockValueObject)
    case numberList(TextAndChildrenBlockValueObject)
    case toggleList(TextAndChildrenBlockValueObject)
    case quotation(QuoteBlockValueObject)
    case separatorLine
    case pageLink(LinkToPageBlockValueObject)
    case callOut(CalloutBlockValueObject)
    case none
    
    func descriptionFunc() -> String{
        var result : String = ""
        if let value = try? self.getBlockValueType() as? TextAndChildrenBlockValueObject{
            for ob in value.richText{
                result += " --- richText: \(ob.description), ----rich----"
            }
            if let children = value.children{
                result += " ---- children: \(children) block ----"
            }
            
            return result
        }
        if let value = try? self.getBlockValueType() as? HeadingBlockValueObject{
            for ob in value.richText{
                result += " --- richText: \(ob.description), ----rich----"
            }
            if let children = value.children{
                result += " ---- children: \(children) block ----"
            }
            
            return result
        }
        return "customBlock description failed"
    }
    
    func editAttributes(_ attributes: [[NSAttributedString.Key : Any]]){
        switch self {
        case .title1(let headingBlockObject):
            changeObjectAnnotaionValue(attributes, headingBlockObject)
        
        case .title2(let headingBlockObject):
            changeObjectAnnotaionValue(attributes, headingBlockObject)
            
        case .title3(let headingBlockObject):
            changeObjectAnnotaionValue(attributes, headingBlockObject)
            
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
    
  
    func editRawText(_ text: String){
        switch self {
        case .paragraph(let textAndChildrenBlockValueObject):
//            textAndChildrenBlockValueObject.richText = [RichTextObject(text: RawTextElement(content: text, link: nil))]
            break
        case .textHeadSymbolList(let textAndChildrenBlockValueObject):
//            textAndChildrenBlockValueObject.richText = [RichTextObject(text: RawTextElement(content: text, link: nil))]
            break
        case .toggleList(let textAndChildrenBlockValueObject):
//            textAndChildrenBlockValueObject.richText = [RichTextObject(text: RawTextElement(content: text, link: nil))]
            break
        default:
            break
        }
    }

    func getBlockValueType() throws -> BlockValueType?{
        switch self{
        case .paragraph(let value):
            return value
        case .title1(let value):
            return value
        case .title2(let value):
            return value
        case .title3(let value):
            return value
        case .textHeadSymbolList(let value):
            return value
        case .toggleList(let value):
            return value
        default:
            throw BlockError.blockValueNilError
        }
    }
    
    func getAttribute() -> [NSAttributedString.Key : Any]{
        switch self{
        case .paragraph:
            return NSAttributedString.Key.defaultParagraphAttribute
        case .textHeadSymbolList:
            return NSAttributedString.Key.textHeadSymbolListAttributes
        case .toggleList:
            return NSAttributedString.Key.toggleAttributes
        default:
            return NSAttributedString.Key.defaultParagraphAttribute
        }
    }
    
    func getAttributes(_ object: BlockValueType) -> [[NSAttributedString.Key : Any]]{
        var attributes: [[NSAttributedString.Key : Any]] = []
        
        switch self{
        case .title1:
            return getHeadingBlockAttributes(type: .title1, object as! HeadingBlockValueObject)
        case .title2:
            return getHeadingBlockAttributes(type: .title2, object as! HeadingBlockValueObject)
        case .title3:
            return getHeadingBlockAttributes(type: .title3, object as! HeadingBlockValueObject)
        case .paragraph:
            let defalutAttributes = NSAttributedString.Key.defaultParagraphAttribute
            return getBlockChildAttributes(defalutAttributes,object as! TextAndChildrenBlockValueObject)
            
        case .textHeadSymbolList:

            let defalutAttributes = NSAttributedString.Key.textHeadSymbolListAttributes
            return getBlockChildAttributes(defalutAttributes,object as! TextAndChildrenBlockValueObject)
            
        case .toggleList:

            let defalutAttributes = NSAttributedString.Key.toggleAttributes
            return getBlockChildAttributes(defalutAttributes,object as! TextAndChildrenBlockValueObject)
            
        default:
            break
        }
      
        
        return attributes
    }
    
    private func getHeadingBlockAttributes(type: CustomBlockType.Base ,
                                           _ object: HeadingBlockValueObject) -> [[NSAttributedString.Key : Any]]{
        var attributes: [[NSAttributedString.Key : Any]] = []
        
        object.richText.forEach{ value in
            
            var attribute: [NSAttributedString.Key : Any]  = NSAttributedString.Key.getTitleAttributes(block: type,
                                                                                                       font: UIFont.preferredFont(block: type))
            let annotations = value.annotations
            
            var font : UIFont = attribute[.font] as! UIFont
            print("original font : \(font)")
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
            print("original new font : \(font)")
            attribute[.font] = font
            if let base = Color.Base(rawValue: annotations.color),
            let color = Color(rawValue: base.rawValue)?.create{
                attribute[.foregroundColor] = color
            }
            
            attributes.append(attribute)
        }
        
        return attributes
        
    }
    
    private func getBlockChildAttributes(_ defaultAtt : [NSAttributedString.Key : Any],
                                         _ object: TextAndChildrenBlockValueObject) -> [[NSAttributedString.Key : Any]] {
        
        var attributes: [[NSAttributedString.Key : Any]] = []
        
        object.richText.forEach{ value in
            
            var attribute: [NSAttributedString.Key : Any]  = defaultAtt
            
            let annotations = value.annotations
//            let color = "label" //annotations.color.create
            
            var font : UIFont = UIFont.appleSDGothicNeo.regular.font(size: 16)
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
        
        return attributes
        
    }
    
    
}
extension CustomBlockType{
    
    enum Base: String{
        case paragraph = "텍스트"
        case page = "페이지"
        case todoList = "할 일 목록"
        case title1 = "제목1"
        case title2 = "제목2"
        case title3 = "제목3"
        case graph = "표"
        case textHeadSymbolList = "글머리 기호 목록"
        case numberList = "번호 매기기 목록"
        case toggleList = "토글 목록"
        case quotation = "인용"
        case separatorLine = "구분선"
        case pageLink = "페이지 링크"
        case callOut = "콜 아웃"
        case none = "none"
    }
    var base: Base {
        switch self {
        case .paragraph:
            return .paragraph
        case .page:
            return .page
        case .todoList:
            return .todoList
        case .title1:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .graph:
            return .graph
        case .textHeadSymbolList:
            return .textHeadSymbolList
        case .numberList:
            return .numberList
        case .toggleList:
            return .toggleList
        case .quotation:
            return .quotation
        case .separatorLine:
            return .separatorLine
        case .pageLink:
            return .pageLink
        case .callOut:
            return .callOut
        case .none:
            return .none
        }
    }
    
  
    
}

final class BlockTypeWrapping: NSObjCoding{
    
    var e: CustomBlockType
    
    
    override var description: String {
        return e.descriptionFunc()
    }
    
    init(_ e: CustomBlockType) {
        self.e = e
    }
    
    enum Key: String{
        case value
        case base
    }
    //MARK: - NSSecureCoding
    static var supportsSecureCoding: Bool {
        true
    }
    
    convenience init?(coder decoder: NSCoder) {
        
        guard let rawBase =  decoder.decodeObject(forKey: Key.base.rawValue) as? String else {return nil}
        
        guard let base =  CustomBlockType.Base(rawValue: rawBase) else {return nil}
        
        let e: CustomBlockType
        
        switch base{
        case .none:
            e = .none
        case .paragraph:
            
            guard let value = decoder.decodeObject(of: TextAndChildrenBlockValueObject.self, forKey: Key.value.rawValue) else { return nil }
            e = .paragraph(value)
            
        case .page:
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? ChildPageBlockValueObject else { return nil }
            e = .page(value)
            
        case .todoList:
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? ToDoBlockValueObject else { return nil }
            e = .todoList(value)
            
        case .title1:
            guard let value = decoder.decodeObject(of: HeadingBlockValueObject.self, forKey: Key.value.rawValue) else { return nil }
            e = .title1(value)
        case .title2:
            guard let value = decoder.decodeObject(of: HeadingBlockValueObject.self, forKey: Key.value.rawValue) else { return nil }
            e = .title2(value)
            
        case .title3:
            guard let value = decoder.decodeObject(of: HeadingBlockValueObject.self, forKey: Key.value.rawValue) else { return nil }
            e = .title3(value)
        case .graph:
            e = .graph
            
        case .textHeadSymbolList:
            guard let value = decoder.decodeObject(of: TextAndChildrenBlockValueObject.self, forKey: Key.value.rawValue) else { return nil }
            e = .textHeadSymbolList(value)
            
        case .numberList:
            guard let value = decoder.decodeObject(of: TextAndChildrenBlockValueObject.self, forKey: Key.value.rawValue) else { return nil }
            e = .numberList(value)
            
        case .toggleList:
            guard let value = decoder.decodeObject(of: TextAndChildrenBlockValueObject.self, forKey: Key.value.rawValue) else { return nil }
            e = .toggleList(value)
            
        case .quotation:
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? QuoteBlockValueObject  else { return nil }
            e = .quotation(value)
                
            
        case .separatorLine:
            e = .separatorLine
            
        case .pageLink:
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? LinkToPageBlockValueObject else { return nil }
                
            e = .pageLink(value)
            
        case .callOut:
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? CalloutBlockValueObject else { return nil }
            e = .callOut(value)
                
        }
        
        self.init(e)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(e.base.rawValue, forKey: Key.base.rawValue)
        
        switch e{
        case .none: break
            
        case .paragraph(let blockObject):
            coder.encode(blockObject, forKey: Key.value.rawValue)
            
        case .page(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .todoList(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .title1(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .title2(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .title3(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .graph:
            break
            
        case .textHeadSymbolList(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .numberList(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .toggleList(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .quotation(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .separatorLine:
            break
            
        case .pageLink(let value):
            coder.encode(value, forKey: Key.value.rawValue)
            
        case .callOut(let value):
            coder.encode(value, forKey: Key.value.rawValue)
        }
    }
    
  
   
}


