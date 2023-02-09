//
//  ParagraphBlock.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import UIKit

class ParagraphBlock:NSObject, BlockElement{
    static var supportsSecureCoding: Bool {
        true
    }
    
    func encode(with coder: NSCoder) {
        
    }
    
    required convenience init?(coder: NSCoder) {
        
//        self.init(richText: RichTextObject(text: RawTextElement(content: "", link: "")))
        self.init(richText: nil)
    }
    
    
    var richText: RichTextElement?
    let color: UIColor?
    var children: [BlockObject]?
    
    var decription: String {
        self.richText?.description ?? "nil"
    }
    
    public init(
        richText: RichTextElement?,
        children: [BlockObject]? = nil,
        color: UIColor? = nil
    ) {
        self.richText = richText
        self.children = children
        self.color = color
    }
    
    func editRawText(_ text: String) {
        richText?.editRawText(text)
    }

}
