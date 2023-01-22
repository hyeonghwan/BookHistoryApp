//
//  TextHead.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/22.
//

import UIKit

final class TextHeadSymbolListBlock: BlockElement{
    
    var richText: RichTextElement?
    
    var children: [BlockObject]?
    
    var color: UIColor?
    
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
