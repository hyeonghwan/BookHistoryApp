//
//  ParagraphValidator.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/12.
//

import Foundation

protocol ParagraphValidInput{
    
    var contentViewModel: ContentViewModelProtocol? { get set }
    var pageViewModel: PageVCValidDelegate? { get set }
    
    func isValidURL()
    
    func isValidBlock(_ text: String,_ paragraphRange: NSRange,_ type: CustomBlockType.Base?) -> Bool
    
    func isValidSelection()
}

typealias ParagraphValidatorProtocol = ParagraphValidInput

class ParagraphValidator: ParagraphValidatorProtocol{
    
    weak var contentViewModel: ContentViewModelProtocol?
    
    weak var pageViewModel: PageVCValidDelegate?
    
    init(){
        
    }
    
    func isValidURL() {
        <#code#>
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
        if self.contentViewModel!.replaceBlockAttribute(text,paragraphRange,.textHeadSymbolList){
            
            guard let viewModel = pageViewModel else {return false}
            guard let restText = viewModel.getRestRangeAndText(paragraphRange) else {return false}
            
            let textToValidData = TextToValidData(text: text,
                                                  restText: restText,
                                                  replaceMent: "리스트",
                                                  paragraphRange: paragraphRange,
                                                  type: .textHeadSymbolList)
            
            return viewModel.resetParagraphToPlaceHodlerAttribute(textToValidData)
        }
    }
    
    private func toggleValid(_ text: String, _ paragraphRange: NSRange) -> Bool{
        if self.contentViewModel!.replaceBlockAttribute(text,paragraphRange,.toggleList){
            
            guard let viewModel = pageViewModel else {return false}
            guard let restText = viewModel.getRestRangeAndText(paragraphRange) else {return false}
            
            let textToValidData = TextToValidData(text: text,
                                                  restText: restText,
                                                  replaceMent: "토글",
                                                  paragraphRange: paragraphRange,
                                                  type: .toggleList)
            
            return viewModel.resetParagraphToPlaceHodlerAttribute(textToValidData)
        }
    }   
}
