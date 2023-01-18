//
//  ToggleBlock.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import UIKit
//{
//  "type": "toggle",
//  //...other keys excluded
//  "toggle": {
//    "rich_text": [{
//      "type": "text",
//      "text": {
//        "content": "Lacinato kale",
//        "link": null
//      }
//    }],
//    "color": "default",
//    "children":[{
//      "type": "paragraph"
//      // ..other keys excluded
//    }]
//  }
//}
protocol BlockObjectType{}
protocol BlockElement{}

struct BlockObject: BlockObjectType{
    let blockType: BlockType?
    let object: BlockElement?
}

struct ToggleBlock : BlockElement{
    let richText: BlockElement?
    let color: UIColor?
    let children: [BlockElement]?
}

struct RichTextElement: BlockElement{
    let type: String = "text"
    let text: RawTextElement
}

struct RawTextElement{
    let content: String?
    let link: String?
}



extension NSAttributedString{
    static let toggleAttributedString: NSAttributedString = NSAttributedString(string: "", attributes: [:])
//    static let toggleAttributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.toggle : "toggle"]
}
