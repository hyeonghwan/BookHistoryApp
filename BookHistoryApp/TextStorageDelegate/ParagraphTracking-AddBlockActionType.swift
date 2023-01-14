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
            break
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
        var style = textStyle
        var font = UIFont.preferredFont(forTextStyle: style, familyName: UIFont.appleFontFamiliyName)
        
        guard let currentIndex = self.ranges.firstIndex(of: range) else {return}
        
        let placeTitleAttribute: [NSAttributedString.Key : Any ] = [.font : font ,
                                                                    .foregroundColor : UIColor.placeHolderColor]
        
        var resultAttributedString = NSMutableAttributedString()
        
        let titleAttributeString = NSAttributedString(string: "제목1",attributes: placeTitleAttribute)
        
        resultAttributedString.append(titleAttributeString)
        
        resultAttributedString.append(NSAttributedString(string: "\n", attributes: NSAttributedString.Key.defaultAttribute))
        
        let insertedRange = ranges[currentIndex]
        if currentIndex == self.ranges.count - 1{
            let lastInsertedString = NSAttributedString(string: "\n제목1",attributes: placeTitleAttribute)
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
