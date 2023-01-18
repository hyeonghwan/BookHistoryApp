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

extension ParagraphTrackingUtility{
    
    func addBlockActionPropertyToTextStorage(_ block: BlockType,_ current: NSRange){
        switch block {
        case .paragraph:
            break
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
        case .textSymbolList:
            break
        case .numberList:
            break
        case .toggleList:
            addToggle(current)
        case .quotation:
            break
        case .separatorLine:
            break
        case .pageLink:
            break
        case .collOut:
            break
        case .none:
            break
        }
    }
    
    private func addTitle(_ textStyle: UIFont.TextStyle,_ range: NSRange){
        
        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
        
        let titleAttributes = NSAttributedString.Key.getPlaceTitleAttribues(textStyle)
        
        var resultAttributedString = NSMutableAttributedString()
        
        let titleAttributeString = NSAttributedString(string: "제목1",attributes:titleAttributes )
        
        resultAttributedString.append(titleAttributeString)
        
        var titleEnterStyle = NSAttributedString.Key.defaultAttribute
        
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
    @objc func toggleButtonClick(_ sender: UIButton){
        print("toggleButtonClick")
    }
    
    func addToggle(_ range: NSRange,_ text: String? = nil){
        
        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
       
        let insertedRange = ranges[currentIndex]
        
        if let restText = text{
            createToggleAttributedString(restText, currentIndex, insertedRange)
            return
        }
        
        createToggleAttributedString(nil,currentIndex, insertedRange)
        
    }
    
    private func createToggleAttributedString(_ text: String? = nil, _ index: Int, _ range: NSRange) {
        
        let plusIndex =  (index < (self.ranges.count - 1)) ? 1 : 2
        let insertedRange = range
        
        var togglString: NSAttributedString
        var resultString: NSAttributedString
        
        if let text = text{
            togglString = NSAttributedString(string: "\(text)", attributes: NSAttributedString.Key.toggleAttributes)
            resultString = insertingToggleAttachment(togglString, attributes: NSAttributedString.Key.toggleAttributes, plusIndex - 1)
        }else{
            if plusIndex == 1{
                togglString = NSAttributedString(string: "토글\n", attributes: NSAttributedString.Key.togglePlaceHolderAttributes)
            }else{
                togglString = NSAttributedString(string: "\n토글", attributes: NSAttributedString.Key.togglePlaceHolderAttributes)
            }
            resultString = insertingToggleAttachment(togglString, attributes: NSAttributedString.Key.togglePlaceHolderAttributes, plusIndex - 1)
        }
        
        self.paragraphStorage?.beginEditing()
        self.paragraphStorage?.insert(resultString, at: insertedRange.max)
        self.paragraphStorage?.endEditing()
        
        self.paragrphTextView?.selectedRange = NSRange(location: insertedRange.max + plusIndex, length: 0)
        
    }
    private func insertingToggleAttachment(_ attString: NSAttributedString ,attributes: [NSAttributedString.Key : Any],_ position: Int) -> NSAttributedString{
        let textElement = RawTextElement(content: "", link: nil)
        let richTextElement = RichTextElement(text: textElement)
        let toggleElement = ToggleBlock(richText: richTextElement, color: nil, children: nil)
        let object = BlockObject(blockType: .toggleList, object: toggleElement)
        
        let dependency = BlockToggleDependency(toggleAction: self,blockObject: object)
        
        let button = BlockToggleButton(frame: .zero,
                                       dependency: dependency)
        
        let attachment = SubviewTextAttachment(view: button,
                                               size: CGSize(width: 35, height: 13))
        
        
        var result = attString.insertingAttachment(attachment, at: position)
        
        result = result.addingAttributes(attributes)
        return result
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
    
}
