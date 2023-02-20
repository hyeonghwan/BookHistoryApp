//
//  ParagraphTracking-AddBlockActionType.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/13.
//

import UIKit
import ParagraphTextKit
import RxCocoa
import RxRelay
import RxSwift
import SubviewAttachingTextView


protocol Add_Init_ToggleActionType{
    func addToggleWhenFirstInit(_ insertIndex: Int,
                                _ count: Int,
                                _ attributesString: NSAttributedString) -> NSAttributedString
}
protocol Add_Init_TextHeadSymbolType{
    func addTextHeadSymbolWhenFirstInit(_ insertIndex: Int,
                                        _ count: Int,
                                        _ attributesString: NSAttributedString) -> NSAttributedString
}

//MARK: - Add_Init_ToggleActionType
extension ParagraphTrackingUtility: Add_Init_ToggleActionType{
    public func addToggleWhenFirstInit(_ insertIndex: Int,
                                       _ count: Int,
                                       _ attributesString: NSAttributedString) -> NSAttributedString{
        
        print("toggleWhenInit : \(attributesString.string)")
        print("toggleWhenInit : \(attributesString.string.count)")
       return insertingToggleAttachment(attString: attributesString,
                                        attributes: nil,
                                        position: 0,
                                        index: insertIndex)
    }
}

//MARK: - Add_Init_TextHeadSymbolType
extension ParagraphTrackingUtility: Add_Init_TextHeadSymbolType{
    public func addTextHeadSymbolWhenFirstInit(_ insertIndex: Int,
                                               _ count: Int,
                                               _ attributesString: NSAttributedString) -> NSAttributedString{
        
        
        print("textHeadWhenInit2 : \(attributesString.string)")
        print("textHeadWhenInit2 : \(attributesString.string.count)")
        
        return insertingTextHeadSymbolListAttachment(attributesString,
                                                     attributes: nil,
                                                     0,
                                                     insertIndex)
    }
}

extension ParagraphTrackingUtility{
    
    func addBlockActionPropertyToTextStorage(_ block: CustomBlockType.Base,_ current: NSRange,_ text: String? = nil){
        switch block {
        case .paragraph:
            addParagraph(current,text)
        case .page:
            break
        case .todoList:
            break
        case .title1:
            addTitle(.title1, current)
        case .title2:
            addTitle(.title2, current)
        case .title3:
            addTitle(.title3, current)
        case .graph:
            break
        case .textHeadSymbolList:
            addTextHeadSymbolList(current)
        case .numberList:
            break
        case .toggleList:
            addToggle(current,text)
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
    }
    
    func resetPlace(_ attributes: [NSAttributedString.Key : Any], _ location: Int){
        let subject = PublishSubject<Int>()
        editObserver = subject.asObserver()
        print("editObserver setting")
        subject
            .observe(on: MainScheduler.instance)
            .take(4)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else {return}
                
                let paragraphRange = self.ranges[index]
                print("paragrphRange for change : \(paragraphRange)")
                
                self.paragraphStorage?.beginEditing()
                self.paragraphStorage?.addAttributes(attributes, range: NSRange(location: paragraphRange.location, length: paragraphRange.length))
                
                self.paragraphStorage?.endEditing()
                
            }).disposed(by: disposeBag)
        
    }

    
    private func addTitle(_ textStyle: UIFont.TextStyle,_ range: NSRange){
        
        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
        
        let titleAttributes = NSAttributedString.Key.getPlaceTitleAttribues(textStyle)
        
        let resultAttributedString = NSMutableAttributedString()
        
        let titleAttributeString = NSAttributedString(string: "제목1",attributes:titleAttributes )
        
        resultAttributedString.append(titleAttributeString)
        
        let titleEnterStyle = NSAttributedString.Key.defaultAttribute
        
        resultAttributedString.append(NSAttributedString(string: " \n", attributes: titleEnterStyle))
        
        let insertedRange = ranges[currentIndex]
        if currentIndex == self.ranges.count - 1{
            let lastInsertedString = NSAttributedString(string: "\n제목1",attributes: titleAttributes)
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.insert(lastInsertedString,
                                          at: insertedRange.max)
            self.paragraphStorage?.endEditing()
            return
        }

        self.paragraphStorage?.beginEditing()
        self.paragraphStorage?.insert(resultAttributedString,
                                      at: insertedRange.max)
        self.paragraphStorage?.endEditing()
        
        
    }
    
}

//MARK: - add Paragraph Logic
extension ParagraphTrackingUtility{
    private func addParagraph(_ range: NSRange, _ text: String? = nil){
        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
        let insertedRange = ranges[currentIndex]
        
        if let restText = text{
            createParagraph(content: restText, at: currentIndex, insert: insertedRange)
            return
        }
        
        createParagraph(content: nil, at: currentIndex, insert: insertedRange)
        
    }
    func createParagraph(content text: String?, at index: Int, insert range: NSRange){
        let insertedRange = range
        var paragraphString: NSAttributedString
        
        if let text = text {
            paragraphString = NSAttributedString(string: text, attributes: NSAttributedString.Key.defaultAttribute)
        }else{
            paragraphString = NSAttributedString(string: String.newLineString(),
                                                 attributes: NSAttributedString.Key.defaultAttribute)
        }
        self.paragrphTextView?.typingAttributes = NSAttributedString.Key.defaultAttribute
        
        self.paragraphStorage?.beginEditing()
        self.paragraphStorage?.insert(paragraphString, at: insertedRange.max)
        self.paragraphStorage?.endEditing()
        
        self.paragrphTextView?.selectedRange = NSRange(location: (insertedRange.max + 1) - paragraphString.length , length: 0)
        
    }
    
}

//MARK: - add Toggle Logic
extension ParagraphTrackingUtility {
    
    private func addToggle(_ range: NSRange,_ text: String? = nil){
        
        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
        
       
        let insertedRange = ranges[currentIndex]
        
        if let restText = text{
            createToggleAttributedString(restText, currentIndex, insertedRange)
            return
        }
        
        createToggleAttributedString(nil,currentIndex, insertedRange)
        
    }
    
    private func createToggleAttributedString(_ text: String? = nil,
                                              _ index: Int,
                                              _ range: NSRange) {
        
        let plusIndex =  (index < (self.ranges.count - 1)) ? 1 : 2
        let insertedRange = range
        
        var togglString: NSAttributedString
        var resultString: NSAttributedString
        
        if let text = text{
            togglString = NSAttributedString(string: "\(text)", attributes: NSAttributedString.Key.toggleAttributes)
            resultString = insertingToggleAttachment(attString: togglString,
                                                     attributes: NSAttributedString.Key.toggleAttributes,
                                                     position: plusIndex - 1,
                                                     index: index)
        }else{
            let spaceString = NSAttributedString.paragraphNewLine
            if plusIndex == 1{
                togglString = NSAttributedString(string: "토글\n", attributes: NSAttributedString.Key.togglePlaceHolderAttributes)
            }else{
                togglString = NSAttributedString(string: "\n토글", attributes: NSAttributedString.Key.togglePlaceHolderAttributes)
            }
            
            resultString = insertingToggleAttachment(attString: togglString,
                                                     attributes: NSAttributedString.Key.togglePlaceHolderAttributes,
                                                     position: plusIndex - 1,
                                                     index: index)
        }
        
        self.paragraphStorage?.beginEditing()
        self.paragraphStorage?.insert(resultString, at: insertedRange.max)
        self.paragraphStorage?.endEditing()
        
        self.paragrphTextView?.selectedRange = NSRange(location: insertedRange.max + plusIndex, length: 0)
        
    }
    private func insertingToggleAttachment(attString: NSAttributedString ,
                                           attributes: [NSAttributedString.Key : Any]? = nil,
                                           position: Int,
                                           index : Int) -> NSAttributedString{
        let blockObjectIndex = index + 1
        var newAttributes: [NSAttributedString.Key : Any] = [:]
        var attString = attString
        if let att = attributes{
            newAttributes = att
        }else{
            
            let (attributes_S,string_S, _): SeparatedNSAttributedString = attString.separatedNSAttributeString()
            let mutableString: NSMutableAttributedString = NSMutableAttributedString(string: "")
            
            string_S.enumerated().forEach{ index ,str in
               let nsAttributedString: NSAttributedString = NSAttributedString(string: str, attributes: attributes_S[index])
               mutableString.append(nsAttributedString)
           }
            attString = mutableString
            
        }
    
        
        let dependency = BlockToggleDependency(toggleAction: self, firstInitIndex: blockObjectIndex)
        
        let button = BlockToggleButton(frame: .zero,
                                       dependency: dependency)
        
        let attachment = SubviewTextAttachment(view: button,
                                               size: CGSize(width: 35, height: 13))
        
        
        var result = attString.insertingAttachment(type: .toggleList,
                                                   attachment: attachment,
                                                   at: position,
                                                   with: NSParagraphStyle.toggleHeadIndentParagraphStyle())
        
        result = result.addingAttributes(newAttributes)
        
        return result
    }
}

//MARK: - addTextHeadSymbolList logic
extension ParagraphTrackingUtility{
    func addTextHeadSymbolList(_ range: NSRange, _ text: String? = nil) {

        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
       
        let insertedRange = ranges[currentIndex]
        
        if let restText = text{
            createTextHeadSymbolListAttributedString(restText, currentIndex, insertedRange)
            return
        }
        
        createTextHeadSymbolListAttributedString(nil,currentIndex, insertedRange)
        
    }
    private func createTextHeadSymbolListAttributedString(_ text: String? = nil,
                                                          _ index: Int,
                                                          _ range: NSRange) {
        
        let plusIndex =  (index < (self.ranges.count - 1)) ? 1 : 2
        let insertedRange = range
        
        var togglString: NSAttributedString
        var resultString: NSAttributedString
        
        if let text = text{
            togglString = NSAttributedString(string: "\(text)", attributes: NSAttributedString.Key.toggleAttributes)
            resultString = insertingTextHeadSymbolListAttachment(togglString, attributes: NSAttributedString.Key.toggleAttributes, plusIndex - 1,index)
        }else{
            if plusIndex == 1{
                togglString = NSAttributedString(string: "리스트\n", attributes: NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes)
            }else{
                togglString = NSAttributedString(string: "\n리스트", attributes: NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes)
            }
            resultString = insertingTextHeadSymbolListAttachment(togglString,
                                                                 attributes: NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes,
                                                                 plusIndex - 1,
                                                                 index)
            
        }
        
        self.paragraphStorage?.beginEditing()
        self.paragraphStorage?.insert(resultString, at: insertedRange.max)
        self.paragraphStorage?.endEditing()
        
        self.paragrphTextView?.selectedRange = NSRange(location: insertedRange.max + plusIndex, length: 0)
        
    }
    private func insertingTextHeadSymbolListAttachment(_ attString: NSAttributedString ,
                                           attributes: [NSAttributedString.Key : Any]?,
                                           _ position: Int,
                                           _ index : Int) -> NSAttributedString{

        var newAttributes: [NSAttributedString.Key : Any] = [:]
        var attString = attString
        
        if let att = attributes{
            newAttributes = att
        }else{
            let (attributes_S,string_S, _): SeparatedNSAttributedString = attString.separatedNSAttributeString()
            let mutableString: NSMutableAttributedString = NSMutableAttributedString(string: "")
            
            string_S.enumerated().forEach{ index ,str in
               let nsAttributedString: NSAttributedString = NSAttributedString(string: str, attributes: attributes_S[index])
               mutableString.append(nsAttributedString)
           }
            
            attString = mutableString
        }
        
        let textHeadSymbolView = TextHeadSymbolView(frame: .zero)
        
        let attachment = SubviewTextAttachment(view: textHeadSymbolView,
                                               size: CGSize(width: 35, height: 13))
        
        
        var result = attString.insertingAttachment(type: .textHeadSymbolList,
                                                   attachment: attachment,
                                                   at: position,
                                                   with: NSParagraphStyle.toggleHeadIndentParagraphStyle())
        
        result = result.addingAttributes(newAttributes)
        
        return result
    }
}
