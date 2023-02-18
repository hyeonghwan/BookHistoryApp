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
    
    func isValidSelection() {
        
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
