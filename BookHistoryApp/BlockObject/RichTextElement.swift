//
//  RichTextElement.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import Foundation


class RichTextElement: BlockElement {
    var children: [BlockElement]?
    
    let type: String = "text"
    let text: RawTextElement
    
    var decription: String {
        self.text.content ?? "nil"
    }
    
    init(text: RawTextElement) {
        self.text = text
    }
    func editRawText(_ text: String) {
        self.text.content = text
    }
}

class RawTextElement{
    var content: String?
    var link: String?
    
    init(content: String?, link: String?) {
        self.content = content
        self.link = link
    }
}
