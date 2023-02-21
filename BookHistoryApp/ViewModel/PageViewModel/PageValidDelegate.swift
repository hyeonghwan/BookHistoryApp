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
   
    
    func resetParagraphToRestTextAttributes(inserted range: NSRange,
                                            title type: CustomBlockType.Base,
                                            replacement text: String,
                                            lastLine flag: Bool) -> Bool{
        guard let textView = pageVC?.textView else {return false}
        let paragraphRange = range
        var text = text
        
        if flag == false{
            text.append(String.newLineString())
        }
 
        let attributedString = NSAttributedString(string: text,
                                                  attributes: NSAttributedString.Key.getTitleAttributes(block: type,
                                                                                                        font: UIFont.preferredFont(block: type)))
        
        let locationDifference = textView.selectedRange.location - paragraphRange.location
        let length = paragraphRange.length - textView.selectedRange.length - locationDifference
        
        textView.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: NSRange(location: textView.selectedRange.max,
                                                           length: length),
                                               with: String.emptyStr())
        textView.textStorage.endEditing()
        
        textView.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: textView.selectedRange, with: attributedString)
        textView.textStorage.endEditing()
        
        textView.selectedRange = NSMakeRange(locationDifference + paragraphRange.location + length - 1, 0)
        return false
    }
    
    func resetParagraphToPlaceHodlerAttribute(paragraphRange: NSRange,
                                              replacement type: CustomBlockType.Base,
                                              lastLine flag: Bool) -> Bool{
        guard let textView = pageVC?.textView else {return false}
        
        var replaceAttributedText: NSAttributedString
        var paragraphRange = paragraphRange
        
        var textAttachmentOffset: Int = 0
        var lengthOffset: Int = 1
        
        if type == .textHeadSymbolList{
            replaceAttributedText = NSAttributedString.textHeadSymbolList_placeHolderString
            textAttachmentOffset = 1
            lengthOffset += 1
        }else if type == .toggleList{
            replaceAttributedText = NSAttributedString.toggle_placeHolderString
            textAttachmentOffset = 1
            lengthOffset += 1
        }else if type == .title1{
            replaceAttributedText = NSAttributedString.title1_placeHolderString
        }else if type == .title2{
            replaceAttributedText = NSAttributedString.title2_placeHolderString
        }
        else if type == .title3{
            replaceAttributedText = NSAttributedString.title3_placeHolderString
        }
        else{
            return false
        }

        if flag {
            paragraphRange = NSMakeRange(paragraphRange.location + textAttachmentOffset,
                                         paragraphRange.length - (lengthOffset - 1))
        }else{
            paragraphRange = NSMakeRange(paragraphRange.location + textAttachmentOffset,
                                         paragraphRange.length - lengthOffset)
        }
        
        
        textView.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: paragraphRange,
                                               with: replaceAttributedText)
        textView.textStorage.endEditing()
        
        textView.selectedRange = NSRange(location: paragraphRange.location, length: 0)
        return false
    }
    
    func replaceBlockAttribute_WhenBackKeyPressed(replace text: String,
                                                  insertedRange inRange: NSRange,
                                                  replaceRange range: NSRange,
                                                  block type: CustomBlockType.Base) -> Bool{
        return true
    }
}
