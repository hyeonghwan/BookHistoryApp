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
   
    
    func resetParagraphTo_RestTextAttributes(inserted range: NSRange,
                                            title type: CustomBlockType.Base,
                                            replacement text: String,
                                            lastLine flag: Bool) -> Bool{
        guard let textView = pageVC?.textView else {return false}
        let paragraphRange = range
        let text = text
        
        let mutable = NSMutableAttributedString()
        
        let attributedString = NSAttributedString(string: text,
                                                  attributes: NSAttributedString.Key.getTitleAttributes(block: type,
                                                                                                        font: UIFont.preferredFont(block: type)))
        mutable.append(attributedString)
        
        if flag == false{
            mutable.append(NSAttributedString.newLineNSAttributed)
        }
        
        
        let locationDifference = textView.selectedRange.location - paragraphRange.location
        let length = paragraphRange.length - textView.selectedRange.length - locationDifference
        
        
        // 짝수 일때 글자수가 같기 때문에 paragraphTextKit이 change를 감지하지 못하는것 같다.
        // 그래서 seletedRange를 전부 empty string으로 바꾸고
        // seletedLocation 에 나머지 text insert
        
        let removeRange = NSRange(location: textView.selectedRange.location,
                                  length: paragraphRange.length - locationDifference)
        textView.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: removeRange,
                                               with: mutable)
        textView.textStorage.endEditing()
        
        textView.selectedRange = NSMakeRange(locationDifference + paragraphRange.location + length , 0)
        return false
    }
    
    func resetParagraphTo_PlaceHodlerAttribute(paragraphRange: NSRange,
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
        }else if type == .todoList{
            replaceAttributedText = NSAttributedString.todo_PlaceHolderString
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
