//
//  ParagraphTracking-AddBlockActionType.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/13.
//

import UIKit
import ParagraphTextKit


extension ParagraphTrackingUtility{
    
    func addBlockActionPropertyToTextStorage(_ block: BlockType,_ current: NSRange){
        switch block {
        case .paragraph:
            break
        case .page:
            break
        case .todoList:
            break
        case .title1:
            addTitle(.title1, current)
        case .title2:
            addTitle(.title2, current)
        case .title3:
            addTitle(.title3, current)
        case .graph:
            break
        case .textSymbolList:
            break
        case .numberList:
            break
        case .toggleList:
            break
        case .quotation:
            break
        case .separatorLine:
            break
        case .pageLink:
            break
        case .collOut:
            break
        case .none:
            break
        }
    }
    
    private func addTitle(_ textStyle: UIFont.TextStyle,_ range: NSRange){
        var currentRange = range
        var style = textStyle
        var font = UIFont.preferredFont(forTextStyle: style, familyName: UIFont.appleFontFamiliyName)
        font.fontDescriptor.withSymbolicTraits(.traitBold)
        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
        
        print("range: \(currentIndex)")
        print("range: \(ranges[currentIndex])")
        let insertedRange = ranges[currentIndex]
        
        
        self.paragraphStorage?.beginEditing()
        self.paragraphStorage?.insert(NSAttributedString(string: "제목1\n",attributes: [.font : font]), at: insertedRange.max)
        self.paragraphStorage?.endEditing()
        
        
    }
    
}
