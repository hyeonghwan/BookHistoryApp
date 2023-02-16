//
//  ParagraphValidator.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/12.
//

import Foundation

protocol ParagraphValidInput{
    func isValidURL()
    
    func isValidBlock(_ text: String,_ paragraphRange: NSRange,_ type: CustomBlockType.Base?) -> Bool
    
    func isValidSelection()
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
    
    func isValidBlock(_ text: String,_ paragraphRange: NSRange,_ type: CustomBlockType.Base?) -> Bool {
        guard let blockType = type else {return true}
        switch blockType {
        case .paragraph:
            return true
        case .page:
            break
        case .todoList:
            break
        case .title1:
            break
        case .title2:
            break
        case .title3:
            break
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
    
    func isValidSelection() {
        
    }
    
}

extension ParagraphValidator{
    
    struct TextToValidData{
        let text: String
        let restText: String
        let replaceMent: String
        let paragraphRange: NSRange
        let type: CustomBlockType.Base
    }
    
    
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
