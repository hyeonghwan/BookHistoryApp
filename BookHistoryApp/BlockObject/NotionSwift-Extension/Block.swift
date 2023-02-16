//
//  PageParentType.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/22.
//

import UIKit
// TextAndChildrenBlockValue ,
//HeadingBlockValue
//ChildPageBlockValue
//TextAndChildrenBlockValue
//ToDoBlockValue
//QuoteBlockValue
//LinkToPageBlockValue
//CalloutBlockValue


public final class BlockType_C: NSObject,NSSecureCoding{
    public static var supportsSecureCoding: Bool {
        true
    }
    
    var type: String?
    
    public init(_ type: String?) {
        self.type = type
    }
    enum Key: String{
        case type = "type"
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(type, forKey: Key.type.rawValue)
    }
    
    public convenience init?(coder: NSCoder) {
        guard let typeRawValue = coder.decodeObject(forKey: Key.type.rawValue) as? String else {return nil}
        
//        guard let blockType = CustomBlockType(rawValue: typeRawValue) else {return nil}
        self.init(typeRawValue)
    }
}




class TextAndChildrenBlockValueObject: NSObject,NSSecureCoding {
    static var supportsSecureCoding: Bool{
        true
    }
    
    public var richText: [RichTextObject]

    public var color: UIColor?
    
    /// field used only for encoding for adding/appending new blocks
//    public var children: [BlockObject]?
//    var chi
    var children: [BlockObject]?
    
    public init(
        richText: [RichTextObject],
        children: [BlockObject]? = nil,
        color: UIColor?
    ) {
        self.richText = richText
        self.children = children
        self.color = color
    }
    
    enum Key: String{
        case richText
        case children
        case color
    }
    
    func encode(with coder: NSCoder) {
        print(richText)
        print(richText.first)
        
        coder.encode(richText, forKey: Key.richText.rawValue)
        
        if let children = children{
            coder.encode(children, forKey: Key.children.rawValue)
        }
        if let color = color{
            coder.encode(color, forKey: Key.color.rawValue)
        }
        print("texstsefasdfadf")
    }
    
    required convenience init?(coder: NSCoder) {
        print("decdoe richText")
        guard let richText = coder.decodeArrayOfObjects(ofClass: RichTextObject.self, forKey: Key.richText.rawValue) else {return nil}
        print("richText: \(richText)")
        
        
        let children = coder.decodeArrayOfObjects(ofClass: BlockObject.self, forKey: Key.children.rawValue)
        print("richText children : \(children)")
        
        let color = coder.decodeObject(forKey: Key.color.rawValue) as? UIColor
        
        self.init(
            richText: richText ,
            children: children,
            color: color
        )
    }
    
  
}


class HeadingBlockValueObject: NSObjCoding {
    static var supportsSecureCoding: Bool {
        true
    }
    
    func encode(with coder: NSCoder) {
        
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(richText: [],color: UIColor.blue)
    }
    
    public let richText: [RichTextObject]
  
    public let color: UIColor
  
    public init(richText: [RichTextObject], color: UIColor) {
        self.richText = richText
        self.color = color
    }
}


class ToDoBlockValueObject {
    public let richText: [RichTextObject]
  
    public let checked: Bool?
    public let color: UIColor
    // field used only for encoding for adding/appending new blocks
    public let children: [BlockObject]?

    public init(richText: [RichTextObject], checked: Bool? = nil, color: UIColor, children: [BlockObject]? = nil) {
        self.richText = richText
        self.checked = checked
        self.color = color
        self.children = children
    }
}

class ChildPageBlockValueObject {
    public let title: String

    public init(title: String) {
        self.title = title
    }
}

class QuoteBlockValueObject {
    public let richText: [RichTextObject]
    public let color: UIColor
    
    // field used only for encoding for adding/appending new blocks
    public let children: [BlockObject]?

    public init(richText: [RichTextObject], children: [BlockObject]? = nil, color: UIColor) {
        self.richText = richText
        self.children = children
        self.color = color
    }
}


class LinkToPageBlockValueObject{
    let page: String = ""
}

class CalloutBlockValueObject {
    public let richText: [RichTextObject]
   
    // field used only for encoding for adding/appending new blocks
    public let children: [BlockObject]?
    public let icon: String?
    public let color: UIColor
  
    public init(richText: [RichTextObject], children: [BlockObject]? = nil, icon: String? = nil, color: UIColor) {
        self.richText = richText
        self.children = children
        self.icon = icon
        self.color = color
    }
}

