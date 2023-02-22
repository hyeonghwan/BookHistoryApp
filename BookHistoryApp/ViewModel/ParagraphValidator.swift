//
//  ParagraphValidator.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/12.
//

import UIKit

protocol PageVCValidDelegate: AnyObject{
    var pageVC: PageVC? {get set}
    func settingValidatorUseCaseDependency(_ validator: ParagraphValidatorProtocol)
    
    func getRestRangeAndText(_ paragraphRange: NSRange) -> String?
    
    func resetParagraphTo_PlaceHodlerAttribute(paragraphRange: NSRange,
                                              replacement type: CustomBlockType.Base,
                                              lastLine flag: Bool) -> Bool
    func replaceBlockAttribute(_ text: String,
                               _ paragraphRange: NSRange,
                               _ blockType: CustomBlockType.Base) -> Bool
    
    func replaceBlockAttribute_WhenBackKeyPressed(replace text: String,
                                                  insertedRange inRange: NSRange,
                                                  replaceRange range: NSRange,
                                                  block type: CustomBlockType.Base) -> Bool
    
    func resetParagraphTo_RestTextAttributes(inserted range: NSRange,
                                            title type: CustomBlockType.Base,
                                            replacement text: String,
                                            lastLine flag: Bool) -> Bool
}

protocol ParagraphValidInput{
    func isValidURL()
    
    func isValidBlock(_ text: String,_ paragraphRange: NSRange,_ type: CustomBlockType.Base?) -> Bool
    
    func isValidSelection(_ textView: UITextView, _ paragraphRange: NSRange)
    
    func replace_when_backKeyPressed(block type: CustomBlockType.Base?, paragraph range: NSRange) -> Bool
    
    
//    func isParagraphRemoveAction(replacement attString: NSAttributedString,
//                                 replaceRange range: NSRange,
//                                 above paragraphRange: NSRange,
//                                 aboveBlock type: CustomBlockType.Base?) -> Bool
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
    
    
    func replace_when_backKeyPressed(block type: CustomBlockType.Base?, paragraph range: NSRange) -> Bool{
        guard let textView = self.pageViewModel?.pageVC?.textView else {return false}
        let paragraphRange = range
        let blockType = type
        
        if textView.selectedRange.length == 0,
           textView.isLineChangeRange(compare: paragraphRange){
            let upParagraphRange = paragraphRange
            let seletedRange = textView.selectedRange
            let replaceRange = textView.getParagraphRange(seletedRange)
            
            let attributedString = textView.textStorage.attributedSubstring(from: replaceRange)
            
            return self.isParagraphRemoveAction(replacement: attributedString,
                                                              replaceRange: replaceRange,
                                                              above: upParagraphRange,
                                                              aboveBlock: blockType)
        }
        
        if let blockType = blockType,
           blockType == .paragraph{
            return true
        }
        
        if let type = blockType{
            let seleted = textView.selectedRange
            // 어느 위치에서 삭제 되었는지
            let difference = (seleted.location - paragraphRange.location)
            
            let firstParagraphRange = textView.getParagraphRange(NSRange(location: paragraphRange.location, length: 0))
            // seletedRange가 singe Line만 포함하고 있을때 early return
            if firstParagraphRange == paragraphRange{
                return true
            }
            
            return backKeyPreesedAndResetPlaceHolder(paragraphRange: paragraphRange,
                                                     difference: difference,
                                                     replace: type)
        }
        return true
    }
    
    func isValidBlock(_ text: String,_ paragraphRange: NSRange,_ type: CustomBlockType.Base? = .paragraph) -> Bool {
        guard let blockType = type else {return true}
        return checkValidBlock(text, paragraphRange, blockType)
    }
    
    func isValidSelection(_ textView: UITextView, _ paragraphRange: NSRange) {
        return self.checkSelectionRange(textView: textView, paragraphRange)
    }
    
    private func isParagraphRemoveAction(replacement attString: NSAttributedString,
                                 replaceRange range: NSRange,
                                 above paragraphRange: NSRange,
                                 aboveBlock type: CustomBlockType.Base?) -> Bool {
        
        guard let blockType = type else {return true}
        return self.checkParagraphRemoveAction(replacement: attString,
                                               replaceRange: range,
                                               above: paragraphRange,
                                               aboveBlock: blockType)
    }
    
    
  
}

//MARK: - link to private method
private extension ParagraphValidator{
    
    func backKeyPreesedAndResetPlaceHolder(paragraphRange: NSRange,
                                           difference: Int,
                                           replace type: CustomBlockType.Base) -> Bool{
        guard let pageViewModel = pageViewModel else {return false}
        guard let textView = pageViewModel.pageVC?.textView else {return false}
        let lastLine = textView.isLastLine(paragraph: paragraphRange) ? true : false
        print("paragraphRange: \(paragraphRange.max)")
        print("paragraphRange: \(textView.getTextCount())")
        switch type{
        case .title1,.title2,.title3:
            
            return titleReplace(textView: textView,
                                paragraph: paragraphRange,
                                difference: difference,
                                block: type,
                                last: lastLine)
            
        case .textHeadSymbolList,.toggleList:
            if difference > 2 {
                return true
            }else{
                return pageViewModel.resetParagraphTo_PlaceHodlerAttribute(paragraphRange: paragraphRange,
                                                                          replacement: type,
                                                                          lastLine: lastLine)
            }
        default:
            return true
        }
        
    }
    
    private func checkValidBlock(_ text: String,_ paragraphRange: NSRange,_ blockType: CustomBlockType.Base) -> Bool{
        
        
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
            return
        }

        if seletedForeGround == UIColor.placeHolderColor{
            textView.selectedRange = NSMakeRange(paragraphRange.location, 0)
            return
            
        }

    }
    
    func checkParagraphRemoveAction(replacement attString: NSAttributedString,
                                    replaceRange range: NSRange,
                                    above paragraphRange: NSRange,
                                    aboveBlock type: CustomBlockType.Base) -> Bool  {
        switch type {
        case .paragraph:
            return true
        case .page:
            return false
        case .todoList:
            return false
        case .title1, .title2, .title3:
            
            return replaceToTitleAttributes(replaceRange: range,
                                            replaceText: attString.string,
                                            to: paragraphRange,
                                            block: type)
        case .graph:
            break
        case .textHeadSymbolList:
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
        case .callOut:
            break
        case .none:
            break
        }
        
        
        return true
    }
    
}


//MARK: - Titlte Block back Key
extension ParagraphValidator{
    func titleReplace(textView: UITextView,
                      paragraph range: NSRange,
                      difference value: Int,
                      block type: CustomBlockType.Base,
                      last line: Bool) -> Bool{
        
        let paragraphRange = range
        let text = textView.selectedSeparatedText(paragraph: paragraphRange)
        let difference = value
        
        guard let pageViewModel = self.pageViewModel else { return false}
        
        if difference == 0{
            if let text = text,
               text.isEmpty{
                return pageViewModel.resetParagraphTo_PlaceHodlerAttribute(paragraphRange: paragraphRange,
                                                                          replacement: type,
                                                                          lastLine: line)
            }else{
                guard let text = text else {return false}
                return pageViewModel.resetParagraphTo_RestTextAttributes(inserted: paragraphRange,
                                                                        title: type,
                                                                        replacement: text,
                                                                        lastLine: line)
            }
        }else{
            if let text = text,
               text.isEmpty{
                if difference == 1{
                    return pageViewModel.resetParagraphTo_PlaceHodlerAttribute(paragraphRange: paragraphRange,
                                                                               replacement: type,
                                                                               lastLine: line)
                }
                return true
                
            }else{
                guard let text = text else {return false}
                return pageViewModel.resetParagraphTo_RestTextAttributes(inserted: paragraphRange,
                                                                        title: type,
                                                                        replacement: text,
                                                                        lastLine: line)
            }
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
        guard let textView = pageViewModel.pageVC?.textView else {return false}
        let lastLine = textView.isLastLine(paragraph: paragraphRange)
        if text.isNewLine(){
            textView.textStorage.beginEditing()
            textView.textStorage.insert(NSAttributedString.paragraphNewLine, at: paragraphRange.max)
            textView.textStorage.endEditing()
            
            textView.textStorage.beginEditing()
            textView.textStorage.setAttributes(NSAttributedString.Key.defaultParagraphAttribute, range: paragraphRange)
            textView.textStorage.endEditing()
            
            
            if lastLine {
                textView.selectedRange = NSRange(location: paragraphRange.max + 1, length: 0)
            }else{
                textView.selectedRange = NSRange(location: paragraphRange.max  , length: 0)
            }
            
            return false
        }
        
        textView.typingAttributes = NSAttributedString.Key.defaultParagraphAttribute
        
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
    
    private func replaceToTitleAttributes(replaceRange range: NSRange,
                                          replaceText text: String,
                                          to paragraphRange: NSRange,
                                          block type: CustomBlockType.Base) -> Bool{
        
        guard let pageViewModel = self.pageViewModel else {return false}
        guard let textView = pageViewModel.pageVC?.textView else {return false}
        
        let replaceRange = range
        var replaceText = text
        let paragraphRange = paragraphRange
        
        let font = UIFont.preferredFont(block: type)
        let titleAttributes = NSAttributedString.Key.getTitleAttributes(block: type,font: font)
        
        if replaceText.endsWith_Newline{
            
            replaceText.removeLast()
            
            textView.textStorage.beginEditing()
            textView.textStorage.replaceCharacters(in: NSRange(location: replaceRange.location, length: replaceRange.length ),
                                                   with: NSAttributedString(string: String.emptyStr(), attributes: textView.typingAttributes))
            textView.textStorage.endEditing()
            
            textView.textStorage.beginEditing()
            textView.textStorage.insert(NSAttributedString(string: replaceText, attributes: titleAttributes),
                                        at: paragraphRange.max - 1)
            textView.textStorage.endEditing()
        }else{
            
            textView.textStorage.beginEditing()
            textView.textStorage.replaceCharacters(in: replaceRange,
                                                   with: NSAttributedString(string: String.emptyStr()))
            textView.textStorage.endEditing()
            
            textView.textStorage.beginEditing()
            textView.textStorage.insert(NSAttributedString(string: replaceText, attributes: titleAttributes),
                                        at: paragraphRange.max - 1)
            textView.textStorage.endEditing()
        }
        textView.selectedRange = NSMakeRange(paragraphRange.max - 1 , 0)
        return false
    }
}

//MARK: - TextHeadSymbolListValid
extension ParagraphValidator{
    private func textHeadSymbolListValid(_ text: String, _ paragraphRange: NSRange) -> Bool{
        guard let pageViewModel = self.pageViewModel else {return false}
        return pageViewModel.replaceBlockAttribute(text, paragraphRange, .textHeadSymbolList)
    }
}

//MARK: - ToggleValid
extension ParagraphValidator{
    private func toggleValid(_ text: String, _ paragraphRange: NSRange) -> Bool{
        guard let pageViewModel = self.pageViewModel else {return false}
        return pageViewModel.replaceBlockAttribute(text, paragraphRange, .toggleList)
    }
}
