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
    
    func resetParagraphToPlaceHodlerAttribute(_ data: ParagraphValidator.TextToValidData) -> Bool{
        guard let textView = pageVC?.textView else {return false}
        
        let restText = data.restText
        let paragraphRange = data.paragraphRange
        let text = data.text
        let replacement = data.replaceMent
        let type = data.type
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        if type == .textHeadSymbolList{
            attributes = NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes
        }else{
            attributes = NSAttributedString.Key.togglePlaceHolderAttributes
        }
        
        if (restText.length == 3 && text == ""){
            textView.textStorage.beginEditing()
            textView.textStorage.replaceCharacters(in: NSRange(location: paragraphRange.location + 1,
                                                               length: paragraphRange.length - 2),
                                                   with: NSAttributedString(string: replacement,
                                                                            attributes: attributes))
            textView.textStorage.endEditing()
            
            textView.selectedRange = NSRange(location: paragraphRange.location + 1, length: 0)
            return false
        }
        return true
    }
    
    func replaceBlockAttribute_WhenBackKeyPressed(replace text: String,
                                                  insertedRange inRange: NSRange,
                                                  replaceRange range: NSRange,
                                                  block type: CustomBlockType.Base) -> Bool{
        return true
    }
}
