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
    
    func editRawText(_ text: String){
        switch self {
        case .paragraph(let textAndChildrenBlockValueObject):
            textAndChildrenBlockValueObject.richText = [RichTextObject(text: RawTextElement(content: text, link: nil))]
      
        case .textHeadSymbolList(let textAndChildrenBlockValueObject):
            textAndChildrenBlockValueObject.richText = [RichTextObject(text: RawTextElement(content: text, link: nil))]
     
        case .toggleList(let textAndChildrenBlockValueObject):
            textAndChildrenBlockValueObject.richText = [RichTextObject(text: RawTextElement(content: text, link: nil))]
            
        default:
            break
        }
    }

    func getBlockValueType() throws -> BlockValueType?{
        switch self{
        case .paragraph(let value):
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
            return NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes
        case .toggleList:
            return NSAttributedString.Key.togglePlaceHolderAttributes
        default:
            return NSAttributedString.Key.defaultAttribute
        }
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
        print("rawBase 123")
        guard let rawBase =  decoder.decodeObject(forKey: Key.base.rawValue) as? String else {return nil}
        print("rawBase : \(rawBase)")
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
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? HeadingBlockValueObject else { return nil }
            e = .title1(value)
            
        case .title2:
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? HeadingBlockValueObject else { return nil }
            e = .title2(value)
            
        case .title3:
            guard let value = decoder.decodeObject(forKey: Key.value.rawValue) as? HeadingBlockValueObject else { return nil }
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


