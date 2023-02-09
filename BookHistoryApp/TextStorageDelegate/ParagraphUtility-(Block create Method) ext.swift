//
//  ParagraphUtility-(Block create Method) ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/19.
//

import UIKit
import ParagraphTextKit


extension ParagraphTrackingUtility {
//    func createToggleBlock() -> BlockObject {
//        
//        let textElement = RawTextElement(content: "", link: nil)
//        let richTextElement = RichTextObject(text: textElement)
//        let toggleElement = ToggleBlock(richText: richTextElement, children: nil, color: nil)
//        let object = BlockObject(blockType: .toggleList, object: toggleElement)
//        
//        return object
//    }
//    
//    func createSeparatedNSAttributedString(_ attributedString: NSAttributedString,
//                                           _ blockType: CustomBlockType.Base) -> SeparatedNSAttributedString{
//        var (att_S, str_S, _): SeparatedNSAttributedString = ([],[],CustomBlockType.Base.none)
//        
//        attributedString.enumerateAttributes(in: attributedString.range,
//                                                                 options: .longestEffectiveRangeNotRequired){
//            attributes, subRange, pointer in
//            
//            let subText = attributedString.attributedSubstring(from: subRange)
//            
//            if subText.string != String.newLineString(){
//                att_S.append(attributes)
//                str_S.append(subText.string)
//                
//            }else{
//                pointer.pointee = true
//            }
//        }
//        return (att_S,str_S, blockType)
//    }
}
