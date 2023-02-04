//
//  RichTextElement.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import Foundation


protocol RichTextElement: NSObjCoding{
    var text: RawTextElement { get }
    var description: String { get }
    func editRawText(_ text: String)
}

class RichTextObject: NSObject, RichTextElement {
    static var supportsSecureCoding: Bool {
        true
    }
    
    var type: String = "text"
    let text: RawTextElement
    
    override var description: String {
        self.text.content ?? "nil"
    }
    
    init(text: RawTextElement) {
        self.text = text
    }
    
    
    enum Key: String {
        case type
        case text
    }
    
    func encode(with coder: NSCoder){
        coder.encode(text, forKey: Key.text.rawValue)
        coder.encode(type, forKey: Key.type.rawValue)
        print("endcoddafljsf :")
    }
    
    required convenience init?(coder: NSCoder) {
        guard let text = coder.decodeObject(of: RawTextElement.self, forKey: Key.text.rawValue) else { return nil}
        print("text; \(text)")
        _ = coder.decodeObject(forKey: Key.type.rawValue) as? String
        self.init(text: text)
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
