//
//  RichTextElement.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import UIKit


protocol RichTextElement: NSObjCoding{
    var text: RawTextElement { get }
    var description: String { get }
    func editRawText(_ text: String)
}

struct Anotations{
    let bold: Bool
    let italic: Bool
    let strikethrough: Bool
    let underline: Bool
    let code: Bool
    let color: String
    
    init(bold: Bool = false,
         italic: Bool = false,
         strikethrough: Bool = false,
         underline: Bool = false,
         code: Bool = false,
         color: String = Color.label.rawValue) {
        self.bold = bold
        self.italic = italic
        self.strikethrough = strikethrough
        self.underline = underline
        self.code = code
        self.color = color
    }
    
    init(bold: Bool? ,
         italic: Bool? ,
         strikethrough: NSUnderlineStyle? ,
         underline: NSUnderlineStyle?,
         code: Bool? ,
         color: String? ) {
        self.bold = bold ?? false
        self.italic = italic ?? false
        self.strikethrough = strikethrough != nil ? true : false
        self.underline = underline != nil ? true : false
        self.code = code ?? false
        self.color = color != nil ? color! : "label"
    }
    
    
    
}
extension Anotations: Equatable{}
extension Anotations: Codable{
//    enum CodingKeys: String, CodingKey {
//          case bold
//          case italic
//          case strikethrough
//          case underline
//          case code
//          case color
//      }
//    
//    public func encode(to encoder: Encoder) throws {
////        var container = encoder.container(keyedBy: CodingKeys.self)
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(bold, forKey: .bold)
//        try container.encode(italic, forKey: .italic)
//        try container.encode(strikethrough, forKey: .strikethrough)
//        try container.encode(underline, forKey: .underline)
//        try container.encode(code, forKey: .code)
//        try container.encode(color.create, forKey: .color)
////        try container.encode(id, forKey: .id)
////        try container.encode(type?.rawValue, forKey: .type)
////        try container.encode(archived, forKey: .archived)
////        try container.encode(createdTime, forKey: .createdTime)
////        try container.encode(lastEditedTime, forKey: .lastEditedTime)
////        try container.encode(hasChildren, forKey: .hasChildren)
////        try container.encode(color, forKey: .color)
////        try container.encode(createdBy, forKey: .createdBy)
////        try container.encode(lastEditedBy, forKey: .lastEditedBy)
//    }
//  public init(from decoder: Decoder) throws {
////      let container = try decoder.container(keyedBy: CodingKeys.self)
////      id = try container.decode(EntityIdentifier_C.self, forKey: .id)
////      let typeValue = try container.decode(String.self, forKey: .type)
////      type = CustomBlockType.Base(rawValue: typeValue) ?? Optional.none
////      archived = try container.decode(Bool.self, forKey: .archived)
////      createdTime = try container.decode(Date.self, forKey: .createdTime)
////      lastEditedTime = try container.decode(Date.self, forKey: .lastEditedTime)
////      hasChildren = try container.decode(Bool.self, forKey: .hasChildren)
////      color = try container.decode(String.self, forKey: .color)
////      createdBy = try container.decode(String.self, forKey: .createdBy)
////      lastEditedBy = try container.decode(String.self, forKey: .lastEditedBy)
//  }
}

class RichTextObject: NSObject, RichTextElement {
    static var supportsSecureCoding: Bool {
        true
    }
    
    var type: String = "text"
    let text: RawTextElement
    
    var annotations: Anotations
    var plain_text: String

    
    override var description: String {
        self.text.content ?? "nil"
    }
    
    init(text: RawTextElement,_ plain : String ,annotations: Anotations) {
        self.text = text
        self.plain_text = plain
        self.annotations = annotations
    }
    
    
    enum Key: String {
        case type
        case text
        case plainText
        case annotations
    }
    
    func encode(with coder: NSCoder){
        print("encode RichTextObject")
        coder.encode(text, forKey: Key.text.rawValue)
        coder.encode(type, forKey: Key.type.rawValue)
        coder.encode(plain_text, forKey: Key.plainText.rawValue)
        
        let encoder = JSONEncoder()
        do{
            let encodedData = try encoder.encode(annotations)
            
            let nsData = NSData(data: encodedData)
            
            coder.encode(nsData, forKey: Key.annotations.rawValue)
        }catch{
            fatalError("error : \(error)")
        }
    }
    
    required convenience init?(coder: NSCoder) {
        
        do{
            guard let text = coder.decodeObject(of: RawTextElement.self, forKey: Key.text.rawValue) else { return nil}
            print("text; \(text)")
            _ = coder.decodeObject(forKey: Key.type.rawValue) as? String
            guard let plain = coder.decodeObject(forKey: Key.plainText.rawValue) as? String else {return nil}
            
            guard let nsData = coder.decodeObject(forKey: Key.annotations.rawValue) as? NSData else {return nil}
            
            let decoder = JSONDecoder()
            
            let annotations = try decoder.decode(Anotations.self, from: nsData as Data)
            
            self.init(text: text, plain, annotations: annotations)
        }catch{
            fatalError("error : \(error)")
            return nil
        }
       
    }
    
   
    func editRawText(_ text: String) {
        self.text.content = text
    }
}

class RawTextElement: NSObjCoding{
    static var supportsSecureCoding: Bool {
        true
    }
    
    var content: String?
    var link: String?
    
    init(content: String?, link: String?) {
        self.content = content
        self.link = link
    }
    
    enum Key: String{
        case content = "content"
        case link = "link"
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encode(content, forKey: Key.content.rawValue)
        coder.encode(link, forKey: Key.link.rawValue)
    }
    
    required convenience init?(coder: NSCoder) {
        print("decode RawTextElement")
        let content = coder.decodeObject(forKey: Key.content.rawValue) as? String
        let link = coder.decodeObject(forKey: Key.link.rawValue) as? String
        self.init(content: content, link: link)
    }
}
