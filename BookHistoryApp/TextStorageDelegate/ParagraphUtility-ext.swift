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
    var textContainerInset: UIEdgeInsets? { get }
    var layoutManager: NSLayoutManager? { get }
}

extension ParagraphTrackingUtility: BlockToggleAction{
    
    var textContainerInset: UIEdgeInsets? {
        guard let textView = self.paragrphTextView else {return nil}
        return textView.textContainerInset
    }
    var layoutManager: NSLayoutManager? {
        guard let textView = self.paragrphTextView else {return nil}
        return textView.layoutManager
    }
 
    func createToggleObservable(_ toggle: Driver<Bool>,_ button: BlockToggleButton) {
        let finishChanging = PublishSubject<Void>()
        var toggleDisposeBag = DisposeBag()
        
        self.changeFinishObserver = finishChanging.asObserver()
        
        finishChanging
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                guard let firstInitIndex = button.firstInitIndex else {return}
                button.object = self.blockObjects[firstInitIndex]
                
                toggleDisposeBag = DisposeBag()
                
            }).disposed(by: toggleDisposeBag)
        
        toggle
            .drive(onNext: { [weak self] flag in
                guard let self = self else {return}
                guard let textView = self.paragrphTextView else {return}
                
                if textView.isFirstResponder == true{
                    NotificationCenter.default.post(Notification(name: Notification.keyDown))
                }
                
                guard let object = button.object else {return}
                
                guard let toggleBlock = object.object?.e as? CustomBlockType  else {return}
                guard let buttonRange = button.blockRange else {return}
                let toggleTitleRange = textView.getParagraphRange(buttonRange)
                
                guard let toggleIndex = self.ranges.firstIndex(where: { $0 == toggleTitleRange }) else {return}
                guard let toggleValue = try? toggleBlock.getBlockValueType() as? TextAndChildrenBlockValueObject else {return}
                
                //if flag is true, toggle must show childern element
                if flag {
                    //show children
                    if toggleValue.children == nil{
                        let insertRange = NSRange(location: self.ranges[toggleIndex].max, length: 0)
                        var string: String
                        
                        if toggleIndex == self.ranges.count - 1{
                            string = "\n빈 토글입니다. 내용을 입력하시거나 드래그해서 가져와 시발련아"
                        }else{
                            string = "빈 토글입니다. 내용을 입력하시거나 드래그해서 가져와 시발련아\n"
                        }
                        let attString = NSAttributedString(string: string, attributes: NSAttributedString.Key.togglePlaceHolderChildAttributes)
                        
                        self.paragraphStorage?.beginEditing()
                        self.paragraphStorage?.replaceCharacters(in: insertRange, with: attString)
                        self.paragraphStorage?.endEditing()
                    }else{
                        
                        var currentChildIndex = toggleIndex

                        toggleValue.children?.forEach{ blockObjects in
                            
                            if let paragraphBlock = try? blockObjects.object?.e.getBlockValueType() as? TextAndChildrenBlockValueObject {
                                let text = paragraphBlock.richText.first?.text.content ?? "\n"
                                
                                var attributes = NSAttributedString.Key.paragrphStyleInTogle
                                
                                attributes[.paragraphStyle] = NSParagraphStyle.toggleChildIndentParagraphStyle()
                                self.paragraphStorage?.beginEditing()
                                self.paragraphStorage?.insert(NSAttributedString(string: text, attributes: attributes), at: self.ranges[currentChildIndex].max)
                                self.paragraphStorage?.endEditing()
                                currentChildIndex += 1
                            }else{
                                print("not paragraphBlock")
                            }
                        }
                    }
                }else{
                    
                    //hide children
                    //paragraphStyle.headIndent != 35 아닐때 까지 반복 해서 range를 search 하여 토글 에 삽입
                    print("current : \(self.paragraphs[toggleIndex])")
                    var hideRange: [NSRange] = []
                    var searchIndex: Int = 0
                    
                    for index in toggleIndex + 1..<self.paragraphs.count{
                        defer{
                            searchIndex += 1
                        }
          
                        
                        guard let attributes = self.paragraphStorage?.attributes(at: self.ranges[index].location, effectiveRange: nil) else {return}
                        
                        guard let childStyle = attributes[.paragraphStyle] as? NSParagraphStyle else {return}
                        
//                        
//                        if let type = attributes[.blockType] as? CustomBlockType.Base{
//                            blockType = type
//                        }else{
//                            blockType = .paragraph
//                        }
//                        
                        
                        if self.isValidParagraphStyle(childStyle){
                           
                            guard let attributedString: NSAttributedString
                                    = self.paragraphStorage?.attributedSubstring(from: self.ranges[index]) else {return}
                            
                            var value: SeparatedNSAttributedString = ([],[],CustomBlockType.Base.none)
                            value =
                            self.attributesArray(from: ParagraphTextStorage.ParagraphDescriptor(attributedString: attributedString,
                                                                                           storageRange: self.ranges[index]))
                            
                            guard let block = BlockCreateHelper.shared.createBlock_to_array(value) else {return}

                            
                            if toggleValue.children == nil{
                                toggleValue.children = []
                                toggleValue.children?.append(block)
                            }else{
                                if searchIndex > (toggleValue.children!.count) - 1{
                                    toggleValue.children?.append(block)
                                }else{
                                    toggleValue.children?[searchIndex] = block
                                }
                            }
                            hideRange.append(self.ranges[index])
                        }else{
                            break
                        }
                        
                    }
                    
                    hideRange.reversed().forEach{ range in
                        self.paragraphStorage?.beginEditing()
                        self.paragraphStorage?.replaceCharacters(in: range, with: "")
                        self.paragraphStorage?.endEditing()
                    }
                   
                }
                
            }).disposed(by: disposeBag)
    }
}
extension ParagraphTrackingUtility{
    
    private func isValidParagraphStyle(_ paragraphStyle: NSParagraphStyle) -> Bool{
        let toggleChildStyle = NSParagraphStyle.toggleChildIndentParagraphStyle()
        
        if (paragraphStyle.headIndent == toggleChildStyle.headIndent) && (paragraphStyle.firstLineHeadIndent == toggleChildStyle.firstLineHeadIndent){
            return true
        }
        return false
    }
    func replaceToggleAttribues(_ text: String,_ range: NSRange,_ blockType: CustomBlockType.Base) -> Bool{
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
                addBlockActionPropertyToTextStorage(blockType, paragraphRange, nil)
            }else{
                if let attribute = attribute,
                   attribute == UIColor.placeHolderColor{
                    addBlockActionPropertyToTextStorage(blockType, paragraphRange, nil)
                    
                }else{
                    addBlockActionPropertyToTextStorage(blockType, paragraphRange, restText)
                    
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
                                      
