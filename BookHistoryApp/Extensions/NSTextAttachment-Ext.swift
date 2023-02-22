//
//  EX.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit



public extension NSTextAttachment {

    convenience init(image: UIImage, size: CGSize? = nil) {
        self.init(data: nil, ofType: nil)

        self.image = image
        if let size = size {
            self.bounds = CGRect(origin: .zero, size: size)
        }
    }

}

extension NSAttributedString {
    
    static var defaultParagraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = 10
        style.paragraphSpacingBefore = 10
        return style
    }
    
    func insertingAttachment(type: CustomBlockType.Base,
                             attachment: NSTextAttachment,
                             at index: Int,
                             with paragraphStyle: NSParagraphStyle? = NSParagraphStyle()) -> NSAttributedString {
        
        let copy = self.mutableCopy() as! NSMutableAttributedString
        
        copy.insertAttachment(type: type,
                              attachment: attachment,
                              at: index,
                              with: paragraphStyle)

        return copy.copy() as! NSAttributedString
    }
    
    

    func addingAttributes(_ attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let copy = self.mutableCopy() as! NSMutableAttributedString
        copy.addAttributes(attributes)

        return copy.copy() as! NSAttributedString
    }

}

extension NSMutableAttributedString {

    func insertAttachment(type: CustomBlockType.Base,
                          attachment: NSTextAttachment,
                          at index: Int,
                          with paragraphStyle: NSParagraphStyle? = NSParagraphStyle()) {
        let plainAttachmentString = NSAttributedString(attachment: attachment)
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes = NSAttributedString.Key.defaultParagraphAttribute
        attributes[.blockType] = type
        attributes[.paragraphStyle] = paragraphStyle
        
        if (paragraphStyle != nil) {
            let attachmentString = plainAttachmentString
                .addingAttributes(attributes)
//            let separatorString = NSAttributedString(string: .paragraphSeparator)

            // Surround the attachment string with paragraph separators, so that the paragraph style is only applied to it
            let insertion = NSMutableAttributedString()
//            insertion.append(separatorString)
            insertion.append(attachmentString)
//            insertion.append(separatorString)
            print("separatorString  \(insertion)")
            self.insert(insertion, at: index)
        } else {
            self.insert(plainAttachmentString, at: index)
        }
    }

    func addAttributes(_ attributes: [NSAttributedString.Key : Any]) {
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
    }

}

public extension String {

    static let paragraphSeparator = "\u{2029}"
    
}
