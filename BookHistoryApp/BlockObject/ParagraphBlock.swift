//
//  ParagraphBlock.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import UIKit

class ParagraphBlock: BlockElement{
    
    var richText: RichTextElement?
    let color: UIColor?
    var children: [BlockObject]?
    
    var decription: String {
        self.richText?.decription ?? "nil"
    }
    
    public init(
        richText: RichTextElement,
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
