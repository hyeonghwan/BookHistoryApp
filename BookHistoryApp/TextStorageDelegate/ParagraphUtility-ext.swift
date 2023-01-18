//
//  ParagraphUtility-ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/16.
//

import ParagraphTextKit
import RxSwift
import RxRelay
import RxCocoa

protocol BlockToggleAction: AnyObject{
    func createToggleObservable(_ toggle: Driver<Bool>)
}

extension ParagraphTrackingUtility: BlockToggleAction{
 
    func createToggleObservable(_ toggle: Driver<Bool>) {
        toggle
            .drive(onNext: { [weak self] flag in
                guard let self = self else {return}
                
                print(flag)
                print("createToggleObservable : \(self)")
            }).disposed(by: disposeBag)
    }
}
extension ParagraphTrackingUtility{
    func replaceToggleAttribues(_ text: String,_ range: NSRange) -> Bool{
        guard let paragraphTextView = self.paragrphTextView else {return false}
        let paragraphRange = range
        
        //toggle 은 첫번째 range 에 NSattachMent를 가지기 때문에 location을 1plus 하였다.
        let attribute = paragraphTextView.textStorage.attribute(.foregroundColor, at: paragraphRange.location + 1, effectiveRange: nil) as? UIColor
        
        if let toggleForeGround = attribute,
        toggleForeGround == UIColor.placeHolderColor,
        text != "\n" {
            
            //toggle 은 첫번째 range 에 NSattachMent를 가지기 때문에 location을 1plus 하였다.
            var toggleRange: NSRange = NSRange(location: paragraphRange.location + 1, length: paragraphRange.length - 2)
            
            if paragraphRange.max == paragraphTextView.text.count{
                toggleRange = NSRange(location: paragraphRange.location + 1, length: paragraphRange.length - 1)
            }
            
            paragraphTextView.textStorage.beginEditing()
            paragraphTextView.textStorage.replaceCharacters(in: toggleRange, with: "")
            paragraphTextView.textStorage.endEditing()
            
            paragraphTextView.textStorage.beginEditing()
            paragraphTextView.textStorage.replaceCharacters(in: NSRange(location: toggleRange.location, length: 0),
                                                   with: NSAttributedString(string: "\(text)",attributes: NSAttributedString.Key.toggleAttributes))
            paragraphTextView.textStorage.endEditing()
            
            paragraphTextView.selectedRange = NSRange(location: toggleRange.location + 1, length: 0)
            return false
        }
        
        if text == "\n"{
            let currentPosition = paragraphTextView.selectedRange
            let paragraphRange = paragraphTextView.getParagraphRange(currentPosition)
            let restLength = paragraphRange.max - currentPosition.location
            
            let restRange = NSRange(location: currentPosition.location, length: restLength)
            
            let restText = self.paragrphTextView?.text(in: self.paragrphTextView!.textRangeFromNSRange(range: restRange)!)
            
            
            if restText == "\n"{
                addToggle(paragraphRange,nil)
            }else{
                if let attribute = attribute,
                   attribute == UIColor.placeHolderColor{
                    addToggle(paragraphRange,nil)
                }else{
                    addToggle(paragraphRange,restText)
                    self.paragraphStorage?.beginEditing()
                    self.paragraphStorage?.replaceCharacters(in: NSRange(location: restRange.location, length: restRange.length - 1), with: "")
                    self.paragraphStorage?.endEditing()
                }
            }
            
            return false
        }
        
        
        return true
    }
}
                                      
