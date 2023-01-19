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
    func createToggleObservable(_ toggle: Driver<Bool>,_ button: BlockToggleButton)
}

extension ParagraphTrackingUtility: BlockToggleAction{
 
    func createToggleObservable(_ toggle: Driver<Bool>,_ button: BlockToggleButton) {
        let finishChanging = PublishSubject<Void>()
        var toggleDisposeBag = DisposeBag()
        
        self.changeFinishObserver = finishChanging.asObserver()
        
        finishChanging
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                guard let index = button.blockObjectIndex else {return}
                button.object = self.blockObject[index]
                toggleDisposeBag = DisposeBag()
            }).disposed(by: toggleDisposeBag)
        
        toggle
            .drive(onNext: { [weak self] flag in
                guard let self = self else {return}
                guard let object = button.object else {return}
                
                //if flag is true, toggle must show childern element
                if flag {
                    //show children
                    guard let toggleBlock = object.object as? ToggleBlock else {return}
                    guard let index = button.blockObjectIndex else {return}
                    
                    if toggleBlock.children == nil{
                        
                        let insertRange = NSRange(location: self.ranges[index].max, length: 0)
                        var string: String
                        
                        if index == self.ranges.count - 1{
                            string = "\n빈 토글입니다. 내용을 입력하시거나 드래그해서 가져와 시발련아"
                        }else{
                            string = "빈 토글입니다. 내용을 입력하시거나 드래그해서 가져와 시발련아\n"
                        }
                        var attString = NSAttributedString(string: string, attributes: NSAttributedString.Key.togglePlaceHolderChildAttributes)
                        
                        self.paragraphStorage?.beginEditing()
                        self.paragraphStorage?.replaceCharacters(in: insertRange, with: attString)
                        self.paragraphStorage?.endEditing()
                    }
                    
                    
                }else{
                    //hide children
                }
                
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
                                      
