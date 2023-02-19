//
//  ParagraphValidator.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/12.
//

import UIKit

protocol ParagraphValidInput{
    func isValidURL()
    
    func isValidBlock(_ text: String,_ paragraphRange: NSRange,_ type: CustomBlockType.Base?) -> Bool
    
    func isValidSelection(_ textView: UITextView, _ paragraphRange: NSRange)
}



typealias ParagraphValidatorProtocol = ParagraphValidInput

class ParagraphValidator: ParagraphValidatorProtocol{
    
    
   
    struct Dependencies{
        var pageViewModel: PageVCValidDelegate
    }
    weak var pageViewModel: PageVCValidDelegate?
   
    init(dependencies: Dependencies? = nil) {
        self.pageViewModel = dependencies?.pageViewModel
    }
    
    func isValidURL() {
        
    }
    
    func isValidBlock(_ text: String,_ paragraphRange: NSRange,_ type: CustomBlockType.Base? = .paragraph) -> Bool {
        guard let blockType = type else {return true}
        switch blockType {
        case .paragraph:
            return paragraphTextValid(text, paragraphRange)
        case .page:
            break
        case .todoList:
            break
        case .title1:
            return titleValid(type:.title1,text: text, at: paragraphRange)
        case .title2:
            return titleValid(type:.title2,text: text, at: paragraphRange)
        case .title3:
            return titleValid(type:.title3,text: text, at: paragraphRange)
        case .graph:
            break
        case .textHeadSymbolList:
            return textHeadSymbolListValid(text, paragraphRange)
        case .numberList:
            break
        case .toggleList:
            return toggleValid(text, paragraphRange)
        case .quotation:
            break
        case .separatorLine:
            break
        case .pageLink:
            break
        case .callOut:
            break
        case .none:
            break
        }
        return true
    }
    
    func isValidSelection(_ textView: UITextView, _ paragraphRange: NSRange) {
        return self.checkSelectionRange(textView: textView, paragraphRange)
    }
  
}

//MARK: - ParagraphSelection Check
extension ParagraphValidator{
    
    func checkSelectionRange(textView: UITextView ,_ paragraphRange: NSRange) {
        let attribute = textView.textStorage.attribute(.foregroundColor, at: paragraphRange.location, effectiveRange: nil)
        var blockAttribute: Any?
        
        if paragraphRange.length > 1{
            blockAttribute = textView.textStorage.attribute(.blockType, at: paragraphRange.location + 1, effectiveRange: nil)
        }
        
        guard let seletedForeGround = attribute as? UIColor else {return}
        guard let blockType = blockAttribute as? CustomBlockType.Base else {return}
        
        if blockType == .title1 || blockType == .title2 || blockType == .title3{
            guard let titleAttributes = textView.textStorage.attribute(.foregroundColor, at: paragraphRange.location, effectiveRange: nil) as? UIColor else { return }
            
            if titleAttributes.isPlaceHolder(){
                textView.selectedRange = NSMakeRange(paragraphRange.location, 0)
            }
            return
        }
    
                
                
        if (blockType == .toggleList ) || (blockType == .textHeadSymbolList){
            var nsRange = NSRange()
            nsRange = paragraphRange
            
            guard let toggleFirstAttribute = textView.textStorage.attribute(.foregroundColor, at: paragraphRange.location , effectiveRange: &nsRange) as? UIColor else {return}
            let toggleParagraphattribute = textView.textStorage.attribute(.foregroundColor, at: nsRange.max , effectiveRange: &nsRange) as? UIColor
            
            
            if toggleFirstAttribute.isPlaceHolder(),
               textView.selectedRange == NSRange(location: paragraphRange.location, length: 0){
                textView.selectedRange = NSMakeRange(paragraphRange.location + 1, 0)
                return
            }
            
            if let toggleForeGround = toggleParagraphattribute,
               toggleForeGround.isPlaceHolder(){
                textView.selectedRange = NSMakeRange(paragraphRange.location + 1, 0)
                return
            }
        }

        if seletedForeGround == UIColor.placeHolderColor{
            textView.selectedRange = NSMakeRange(paragraphRange.location, 0)
            return
            
        }
    }
}



//MARK: - ParagraphValid
extension ParagraphValidator{
    
    struct TextToValidData{
        let text: String
        let restText: String
        let replaceMent: String
        let paragraphRange: NSRange
        let type: CustomBlockType.Base
    }
    
    private func paragraphTextValid(_ text: String, _ paragraphRange: NSRange) -> Bool{
        guard let pageViewModel = self.pageViewModel else {return false}
        return true
    }
}

//MARK: - TitleValid
extension ParagraphValidator{
    private func titleValid(type: CustomBlockType.Base,text: String,at paragraphRange: NSRange) -> Bool{
        guard let pageViewModel = self.pageViewModel else {return false}
        if pageViewModel.replaceBlockAttribute(text, paragraphRange, type){
            
            return true
        }
        
        return false
    }
}

//MARK: - TextHeadSymbolListValid
extension ParagraphValidator{
    private func textHeadSymbolListValid(_ text: String, _ paragraphRange: NSRange) -> Bool{
        guard let pageViewModel = self.pageViewModel else {return false}
        if pageViewModel.replaceBlockAttribute(text,paragraphRange,.textHeadSymbolList){
            
            guard let restText = pageViewModel.getRestRangeAndText(paragraphRange) else {return false}
            
            let textToValidData = TextToValidData(text: text,
                                                  restText: restText,
                                                  replaceMent:"리스트",
                                                  paragraphRange: paragraphRange,
                                                  type: .textHeadSymbolList)
            
            return pageViewModel.resetParagraphToPlaceHodlerAttribute(textToValidData)
        }
        return false
    }
}

//MARK: - ToggleValid
extension ParagraphValidator{
    private func toggleValid(_ text: String, _ paragraphRange: NSRange) -> Bool{
        guard let pageViewModel = self.pageViewModel else {return false}
        if pageViewModel.replaceBlockAttribute(text,paragraphRange,.toggleList){
            
            guard let restText = pageViewModel.getRestRangeAndText(paragraphRange) else {return false}
            
            let textToValidData = TextToValidData(text: text,
                                                  restText: restText,
                                                  replaceMent: "토글",
                                                  paragraphRange: paragraphRange,
                                                  type: .toggleList)
            
            return pageViewModel.resetParagraphToPlaceHodlerAttribute(textToValidData)
        }
        return false
    }
}
