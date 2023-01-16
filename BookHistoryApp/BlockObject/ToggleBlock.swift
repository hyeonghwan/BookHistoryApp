//
//  ToggleBlock.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import Foundation
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

extension NSAttributedString{
    static let toggleAttributedString: NSAttributedString = NSAttributedString(string: "", attributes: [:])
//    static let toggleAttributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.toggle : "toggle"]
}
