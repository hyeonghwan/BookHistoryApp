//
//  ColorBlockManager.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/11.
//

import UIKit

class ColorBlockManager {
    
    
    let allKey: [NSAttributedString.Key] = [
        NSAttributedString.Key.paragraphStyle,
        NSAttributedString.Key.backgroundColor
    ]
    
    init(){
        
    }
    
    static func settingColorString(_ color: UIColor) -> [NSAttributedString.Key : Any] {
        let richText = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 20
        
        // Note that setting paragraphStyle.firstLineHeadIndent
        // doesn't use the background color for the first line's
        // indentation. Use a tab stop on the first line instead.
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: paragraphStyle.headIndent, options: [:])]

        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.backgroundColor: color
        ]
        let chunk1 = NSAttributedString(string: "\n", attributes: attributes)
        
        richText.append(chunk1)
  
        
        return attributes
    }
}
