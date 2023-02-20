//
//  PageValidDelegate.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/19.
//

import UIKit

extension PageVCViewModel: PageVCValidDelegate{
    
    func settingValidatorUseCaseDependency(_ validator: ParagraphValidatorProtocol) {
        self.paragraphValidator = validator
    }
    
    func replaceBlockAttribute(_ text: String, _ paragraphRange: NSRange, _ blockType: CustomBlockType.Base) -> Bool {
        return contentViewModel.replaceBlockAttribute(text, paragraphRange, blockType)
    }
    
    
    func getRestRangeAndText(_ paragraphRange: NSRange) -> String?{
        guard let restRange = pageVC?.textView.textRangeFromNSRange(range: paragraphRange) else {return nil}
        guard let restText = pageVC?.textView.text(in: restRange) else {return nil}
        return restText
    }
    
    func resetParagraphToPlaceHodlerAttribute(paragraphRange: NSRange,
                                              replacement type: CustomBlockType.Base,
                                              lastLine flag: Bool) -> Bool{
        guard let textView = pageVC?.textView else {return false}
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        var replaceText: String = ""
        var paragraphRange = paragraphRange
        
        if type == .textHeadSymbolList{
            attributes = NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes
            replaceText = "리스트"
        }else{
            attributes = NSAttributedString.Key.togglePlaceHolderAttributes
            replaceText = "토글"
        }
        
        if flag {
            paragraphRange = NSMakeRange(paragraphRange.location + 1, paragraphRange.length - 1)
        }else{
            paragraphRange = NSMakeRange(paragraphRange.location + 1, paragraphRange.length - 2)
        }
        
        
        textView.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: paragraphRange,
                                               with: NSAttributedString(string: replaceText,
                                                                        attributes: attributes))
        textView.textStorage.endEditing()
        
        textView.selectedRange = NSRange(location: paragraphRange.location + 1, length: 0)
        return false
    }
    
    func replaceBlockAttribute_WhenBackKeyPressed(replace text: String,
                                                  insertedRange inRange: NSRange,
                                                  replaceRange range: NSRange,
                                                  block type: CustomBlockType.Base) -> Bool{
        return true
    }
}
