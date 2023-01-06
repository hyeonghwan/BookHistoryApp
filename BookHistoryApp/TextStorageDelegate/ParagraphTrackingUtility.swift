//
//  ParagraphTrackingUtility.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/21.
//

import Foundation
import ParagraphTextKit

final class ParagraphTrackingUtility: ParagraphTextStorageDelegate{
 
    var paragraphs: [String] = []
    var attributes: [[NSAttributedString.Key: Any]] = []
    
    var insertions: [Int] = []
    var removals: [Int] = []
    var editions: [Int] = []
    
    
    private var firstInit = true
    
    var ranges: [NSRange] {
        var location = 0
        
        return paragraphs.map { string -> NSRange in
            let range = NSRange(location: location, length: string.length)
            location = range.max
            return range
        }
    }
    
    var presentedParagraphs: [NSAttributedString] {
         paragraphs.map{ $0.attributedPresentation }
    }
    
    func textStorage(_ textStorage: ParagraphTextStorage, didChangeParagraphs changes: [ParagraphTextStorage.ParagraphChange]) {
        for change in changes {
            switch change {
            case .insertedParagraph(index: let index, descriptor: let paragraphDescriptor):
                if firstInit {
                    firstInit = false
                } else {
                    insertions.append(index)
                }
                
                paragraphs.insert(paragraphDescriptor.text, at: index)
                attributes.insert(attributes(from: paragraphDescriptor), at: index)
                
            case .removedParagraph(index: let index):
                paragraphs.remove(at: index)
                attributes.remove(at: index)
                removals.append(index)
                
            case .editedParagraph(index: let index, descriptor: let paragraphDescriptor):
                paragraphs[index] = paragraphDescriptor.text
                attributes[index] = attributes(from: paragraphDescriptor)
                editions.append(index)
            }
        }
        print("self.presentedParagraphs:::: \(self.presentedParagraphs)")
        
    }
    
    func attributes(from paragraphDescriptor: ParagraphTextStorage.ParagraphDescriptor) -> [NSAttributedString.Key: Any] {
        if !paragraphDescriptor.text.isEmpty {
            return paragraphDescriptor.attributedString.attributes(at: 0, effectiveRange: nil)
        }
        return [:]
    }
}
