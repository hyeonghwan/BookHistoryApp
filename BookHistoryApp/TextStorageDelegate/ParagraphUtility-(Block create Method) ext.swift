//
//  ParagraphUtility-(Block create Method) ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import Foundation
import ParagraphTextKit


extension ParagraphTrackingUtility {
    func createToggleBlock() -> BlockObject {
        
        let textElement = RawTextElement(content: "", link: nil)
        let richTextElement = RichTextElement(text: textElement)
        let toggleElement = ToggleBlock(richText: richTextElement, children: nil, color: nil)
        let object = BlockObject(blockType: .toggleList, object: toggleElement)
        
        return object
    }
}
