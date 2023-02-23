//
//  NSParagraphStyle - ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import UIKit

extension NSParagraphStyle{
    
    static func nsAttachmentHeadIndentParagraphStyle() -> NSParagraphStyle{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 35
        return paragraphStyle
    }
    static func todoParagraphStyle() -> NSParagraphStyle{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        
        paragraphStyle.headIndent = 35
        paragraphStyle.alignment = .center
        return paragraphStyle
    }
    
    static func toggleChildIndentParagraphStyle() -> NSParagraphStyle{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 35
        paragraphStyle.headIndent = 35
        return paragraphStyle
    }
    
    static func defaultParagraphStyle() -> NSParagraphStyle{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 1
        paragraphStyle.paragraphSpacingBefore = 1
        return paragraphStyle
    }
    
    static func titleParagraphStyle() -> NSParagraphStyle{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 20
        return paragraphStyle
    }
    
}
