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

protocol BlockAttachmentAction: AnyObject{
    func createToggleObservable(_ toggle: Driver<Bool>,_ button: BlockToggleButton)
    func createTodoObservable(_ todo: Driver<Void>, _ button: TodoBlcokButton)
    var textContainerInset: UIEdgeInsets? { get }
    var layoutManager: NSLayoutManager? { get }
}

extension ParagraphTrackingUtility: BlockAttachmentAction{
    
    var textContainerInset: UIEdgeInsets? {
        guard let textView = self.paragrphTextView else {return nil}
        return textView.textContainerInset
    }
    var layoutManager: NSLayoutManager? {
        guard let textView = self.paragrphTextView else {return nil}
        return textView.layoutManager
    }
    
    func createTodoObservable(_ todo: Driver<Void>, _ button: TodoBlcokButton) {
        todo
            .drive(onNext: { _ in
                print("crated TodoObservable: \(button.checked)")
            }).disposed(by: disposeBag)
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
                if self.blockObjects.count >= button.firstInitIndex ?? Int.max {
                    return
                }
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
                guard let blockRange = button.blockRange else {return}
                
                guard let index = self.ranges.firstIndex(of: blockRange) else {return}
                
                guard let toggleBlock = self.blockObjects[index] else {return}
                
        
                guard let toggleValue = toggleBlock.getBlockValueType() as? TextAndChildrenBlockValueObject else {return}
                
                //if flag is true, toggle must show childern element
                if flag {
                    //show children
                    self.toggleStrechAction(toggleValue, block: blockRange, index: index)
                }else{
                    
                    //hide children
                    //paragraphStyle.headIndent != 35 아닐때 까지 반복 해서 range를 search 하여 토글 에 삽입
                    print("current : \(self.paragraphs[index])")
                    var hideRange: [NSRange] = []
                    var searchIndex: Int = 0
                    
                    for index in index + 1..<self.paragraphs.count{
                        defer{
                            searchIndex += 1
                        }
          
                        guard let attributes = self.paragraphStorage?.attributes(at: self.ranges[index].location, effectiveRange: nil) else {return}
                        
                        guard let childStyle = attributes[.paragraphStyle] as? NSParagraphStyle else {return}
                        
                        if self.isValidParagraphStyle(childStyle){
                           
                            guard let attributedString: NSAttributedString
                                    = self.paragraphStorage?.attributedSubstring(from: self.ranges[index]) else {return}
                            
                            var value: SeparatedNSAttributedString = ([],[],CustomBlockType.Base.none)
                            value =
                            self.attributesArray(index: index,from: ParagraphTextStorage.ParagraphDescriptor(attributedString: attributedString,
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

//MARK: toggle show children Logic, toggle Action
extension ParagraphTrackingUtility{
    func toggleStrechAction(_ toggleValue: TextAndChildrenBlockValueObject,
                            block range: NSRange,
                            index: Int){
        if toggleValue.children == nil{
            let insertRange = NSRange(location: range.max , length: 0)
            
            let mutable = NSMutableAttributedString()
            
            if self.isLastLine(index){
                mutable.append(NSAttributedString.paragraphNewLine)
                mutable.append(NSAttributedString.toggle_ChildPlaceHolderString)
            }else{
                mutable.append(NSAttributedString.toggle_ChildPlaceHolderString)
                mutable.append(NSAttributedString.paragraphNewLine)
            }
            
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.replaceCharacters(in: insertRange, with: mutable)
            self.paragraphStorage?.endEditing()
        }else{
            
            var currentChildIndex = index
            
            toggleValue.children?.forEach{ blockObjects in
                
                if let blockValueType = blockObjects.getBlockValueType() {
                    let text = blockValueType.richText.first?.text.content ?? "\n"
                    
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
    }
}


//MARK: replace Logic
extension ParagraphTrackingUtility{
    private func replaceParagraph(content text: String,
                                  attributes: [NSAttributedString.Key : Any],
                                  to textView: UITextView,
                                  at replaceRange: NSRange) -> Bool{
        
        textView.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: replaceRange, with: "")
        textView.textStorage.endEditing()
        
        textView.textStorage.beginEditing()
        textView.textStorage.replaceCharacters(in: NSRange(location: replaceRange.location, length: 0),
                                               with: NSAttributedString(string: "\(text)",
                                                                        attributes: attributes))
        textView.textStorage.endEditing()
        
        textView.selectedRange = NSRange(location: replaceRange.location + text.count, length: 0)
        
        return false
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
    
    
    
    func replaceTitleAttributes(_ text: String,_ range: NSRange,_ type: CustomBlockType.Base) -> Bool{
        guard let paragraphTextView = self.paragrphTextView else {return false}
        let paragraphRange = range
        
        //toggle,textHeadSymbol 은 첫번째 range 에 NSTextAttachMent를 가지기 때문에 location을 1plus 하였다.
        let attribute = paragraphTextView.textStorage.attribute(.foregroundColor, at: paragraphRange.location , effectiveRange: nil) as? UIColor
        
        
        if let toggleForeGround = attribute,
           toggleForeGround.isPlaceHolder(),
           !text.isNewLine(){
            let replaceRange: NSRange = paragraphRange.titleReplaceRange(textView: paragraphTextView.getTextCount())
            
            let font = UIFont.preferredFont(block: type)
            let titleAttributes = NSAttributedString.Key.getTitleAttributes(block: type,font: font)
            
            return self.replaceParagraph(content: text,
                                         attributes: titleAttributes,
                                         to: paragraphTextView,
                                         at: replaceRange)
        }
        
        
        if text.isNewLine(){
            let paragraphRange = paragraphTextView.getCurrentParagraphRange()
            let restRange = paragraphTextView.getTheRestRange(range: paragraphRange)
            let restText = paragraphTextView.getTheRestText(paragrah: paragraphRange, restRange: restRange)
            paragraphTextView.typingAttributes = NSAttributedString.Key.defaultParagraphAttribute
            
            if let restText = restText,
               restText.isNewLine(){
                
                addBlockActionPropertyToTextStorage(.paragraph, paragraphRange, nil)
                
            }else{
                if let attribute = attribute,
                   attribute == UIColor.placeHolderColor{
                    addBlockActionPropertyToTextStorage(.paragraph, paragraphRange, nil)
                }else{
                    if let restText = restText,
                       restText.isEmpty{
                        addBlockActionPropertyToTextStorage(.paragraph, paragraphRange, restText)
                        return true
                    }else{
                        addBlockActionPropertyToTextStorage(.paragraph, paragraphRange, restText)
                        self.paragraphStorage?.beginEditing()
                        self.paragraphStorage?.replaceCharacters(in: NSRange(location: restRange.location, length: restRange.length - 1), with: String.emptyString())
                        self.paragraphStorage?.endEditing()
                    }
                }
            }
            paragraphTextView.typingAttributes = NSAttributedString.Key.defaultParagraphAttribute
            return false
        }
        return true
    }
    
    
    /// toggle OR TextHeadSymbol replace paragraph when current ForeGroundColor is placeHolderColor
    /// - Parameters:
    ///   - text: input text from KeyBoard
    ///   - range: current ParagraphRange
    ///   - blockType: currentBlocktype , exactly this type is toggle OR TextHeadSymbol
    /// - Returns: return bool , when this type is ture -> not occur replaceCharacters , false -> occur replaceCharacters
    func replaceToggleAttribues(_ text: String,_ range: NSRange,_ blockType: CustomBlockType.Base) -> Bool{
        guard let paragraphTextView = self.paragrphTextView else {return false}
        let paragraphRange = range
        
        //toggle,textHeadSymbol 은 첫번째 range 에 NSTextAttachMent를 가지기 때문에 location을 1plus 하였다.
        let attribute = paragraphTextView.textStorage.attribute(.foregroundColor, at: paragraphRange.location + 1, effectiveRange: nil) as? UIColor
        
        
        if let toggleForeGround = attribute,
           toggleForeGround.isPlaceHolder(),
           !text.isNewLine(){
            
            let replaceRange: NSRange = paragraphRange.toggleReplaceRange(textView: paragraphTextView.getTextCount())
            return self.replaceParagraph(content: text,
                                         attributes: NSAttributedString.Key.toggleAttributes,
                                         to: paragraphTextView,
                                         at: replaceRange)
        }
        
        if text.isNewLine(){
            let paragraphRange = paragraphTextView.getCurrentParagraphRange()
            let restRange = paragraphTextView.getTheRestRange(range: paragraphRange)
            let restText = paragraphTextView.getTheRestText(paragrah: paragraphRange, restRange: restRange)
            
            if let restText = restText,
               restText.isNewLine(){
                addBlockActionPropertyToTextStorage(blockType, paragraphRange, nil)
            }else{
                if let attribute = attribute,
                   attribute == UIColor.placeHolderColor{
                    addBlockActionPropertyToTextStorage(blockType, paragraphRange, nil)
                }else{
                    if let remainText = restText,
                       remainText.isEmpty{
                        addBlockActionPropertyToTextStorage(blockType, paragraphRange, nil)
                    }else{
                        addBlockActionPropertyToTextStorage(blockType, paragraphRange, restText)
                        self.paragraphStorage?.beginEditing()
                        self.paragraphStorage?.replaceCharacters(in: NSRange(location: restRange.location, length: restRange.length - 1), with: String.emptyString())
                        self.paragraphStorage?.endEditing()
                    }
                }
            }
            return false
        }
        return true
    }
}
                                      
