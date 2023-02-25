//
//  ParagraphTrackingUtility.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/21.
//

import Foundation
import ParagraphTextKit
import SubviewAttachingTextView
import RxSwift




enum BlockDirection{
    case up
    case down
}

protocol BlockTrackingToCoreDataConvertible{
    
}

typealias SeparatedNSAttributedString = ([[NSAttributedString.Key : Any]], [String], CustomBlockType.Base)

final class ParagraphTrackingUtility: NSObject, ParagraphTextStorageDelegate{
    
    weak var paragraphStorage: ParagraphTextStorage? {
        didSet{
            self.paragraphStorage?.delegate = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.insertions = []
                self.removals = []
                self.editions = []
            })
        }
    }
    
    weak var subAttachMentBehavior: SubviewAttachingTextViewBehavior?
    
    
    weak var paragrphTextView: UITextView?
    
    override init(){
        super.init()
    }
    
    var paragraphs: [String] = []
    var attributes: [[NSAttributedString.Key: Any]] = []
    
    
    var newParagraphs: [[String]] = []{
        didSet{
            print("newParagraphs : \(newParagraphs.count)")
            print("block Object: \(blockObjects.count)")
        }
    }
    var newAttributes: [[[NSAttributedString.Key : Any]]] = [[]]{
        didSet{
            print("newAttributesx : \(newAttributes.count)")
        }
    }
    
    var blockTypes: [CustomBlockType.Base] = []
    
    var blockObjects: [BlockObject?] = [] {
        didSet{
            print("blockObjects : \(blockObjects.count)")
        }
    }
    private let blockObjectqueue = DispatchQueue(label: "com.example.propertyclass.array", attributes: .concurrent)
    
    var blocks: [BlockObject?] {
        get {
            return blockObjectqueue.sync { blockObjects }
        }
        set {
            blockObjectqueue.async(flags: .barrier) {
                self.blockObjects = newValue
            }
        }
    }
    
    
    var editObserver: AnyObserver<Int>?
    
    var changeFinishObserver: AnyObserver<Void>?
    
    var insertions: [Int] = []{
        didSet{
        }
    }
    var removals: [Int] = []{
        didSet{
        }
    }
    var editions: [Int] = []{
        didSet{
        }
    }
    
    var disposeBag = DisposeBag()
    
    
    
    private var firstInit = true
    
    var ranges: [NSRange] {
        var location = 0
        
        return paragraphs.enumerated().map{ index, string -> NSRange in
            let length: Int = string.length
            print("self.range string: \(string)")
            let range = NSRange(location: location, length: length)
            location = range.max
            return range
        }
    }
    
    //MARK: - ParagraphTextStorageDelegate property
    var presentedParagraphs: [NSAttributedString] {
        return newPresentedParagraphs
    }
    
    var newPresentedParagraphs: [NSAttributedString]{
        return self.newParagraphs.enumerated().map{ paragraph_index,paragraphs_d in
            let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: ""))
            paragraphs_d.enumerated().forEach{ index_element, string in
                
                var attributes: [NSAttributedString.Key : Any] = [:]
                
                if paragraph_index > newAttributes.count - 1{
                    attributes = NSAttributedString.Key.defaultParagraphAttribute
                }else{
                    attributes = newAttributes[paragraph_index][index_element]
                }
                
                var text = string
                
                // newLine 이 current paragraph의 속성을 가지고 있으면
                // enter 입력 (line change)후 text 를 입력했을때 single character는 typingAttribute가 적용되지만,
                // ㅇ -> 아 한글입력 에서 문자 'ㅇ' -> "아" 로 입력시 1. remove후 2. replace 의 과정이 생긴다.
                // 이전range( -1 )의 attribute로 replace 된다.
                // 그래서 firstinit시 사용하는 newParagraphTrackingUtility에서 \n 의 속성을 default로 해준다.
                if text.removeLastIfEnter(){
                    let att = NSAttributedString(string: text, attributes: attributes)
                    attributedString.append(att)
                    attributedString.append(NSAttributedString.paragraphNewLine)
                }else{
                    let att = NSAttributedString(string: text, attributes: attributes)
                    attributedString.append(att)
                }
            }
            return attributedString
        }
    }
    
    //MARK: - ParagraphTextStorageDelegate func
    public func insertNSTextAttachMent(_ index: Int,
                                _ attributedString: NSAttributedString) -> NSAttributedString?{
        
        guard let blocktype = attributedString.attribute(.blockType, at: 0, effectiveRange: nil) as? CustomBlockType.Base else {
            return nil
        }
        switch blocktype {
        case .paragraph:
            return nil
        case .todoList:
            self.newParagraphs[index].insert("\u{fffc}", at: 0)
            self.paragraphs[index].insert(Character("\u{fffc}"), at: self.paragraphs[index].startIndex)
            return addTodoListWhenFirstInit(index,
                                            self.paragraphs.count,
                                            attributedString)
        case .toggleList:
            self.newParagraphs[index].insert("\u{fffc}", at: 0)
            self.paragraphs[index].insert(Character("\u{fffc}"), at: self.paragraphs[index].startIndex)
            return addToggleWhenFirstInit(index,
                                          self.paragraphs.count ,
                                          attributedString)
        case .textHeadSymbolList:
            self.newParagraphs[index].insert("\u{fffc}", at: 0)
            self.paragraphs[index].insert(Character("\u{fffc}"), at: self.paragraphs[index].startIndex)
            return addTextHeadSymbolWhenFirstInit(index,
                                                  self.paragraphs.count ,
                                                  attributedString)
        default:
            return nil
        }
    }
    
    //MARK: - ParagraphTextStorageDelegate func
    func textStorage(_ textStorage: ParagraphTextStorage, didChangeParagraphs changes: [ParagraphTextStorage.ParagraphChange]) {
        
        defer{
            
        }
        
        for change in changes {
            
            switch change {
            case .insertedParagraph(index: let index, descriptor: let paragraphDescriptor):
                
                self.insertions.append(index)
                if self.firstInit {
                    self.firstInit = false
                } else {
                    self.insertions.append(index)
                }
                
                let separatedNSAttString = self.attributesArray(index:index,from: paragraphDescriptor)
                
                self.newParagraphs.insert(separatedNSAttString.1, at: index)
                self.newAttributes.insert(separatedNSAttString.0, at: index)
                
                let blockType = separatedNSAttString.2
                
                self.blockTypes.insert( blockType, at: index)
                
                
                guard let blockObj = BlockCreateHelper.shared.createBlock_to_array(separatedNSAttString) else {return}
                self.blockObjects.insert(blockObj, at: index)
                print(self.blockObjects[index]?.object)
                
                let allAttributes = self.attributes(from: paragraphDescriptor)
                self.paragraphs.insert(paragraphDescriptor.text, at: index)
                //                attributes.insert(allAttributes, at: index)
                
            case .removedParagraph(index: let index):
                self.removals.append(index)
                self.newParagraphs.remove(at: index)
                self.newAttributes.remove(at: index)
                
                self.paragraphs.remove(at: index)
                self.blockTypes.remove(at: index)
                self.blockObjects.remove(at: index)
                //              self.  attributes.remove(at: index)
                
                self.removals.append(index)
                
            case .editedParagraph(index: let index, descriptor: let paragraphDescriptor):
                
                self.editions.append(index)
              
                self.editObserver?.onNext(index)
                
                // test separate
                let separatedNSAttString = self.attributesArray(index: index,from: paragraphDescriptor)
               print("separatedNSAttString: \(separatedNSAttString)")
                self.editBlock(from: separatedNSAttString, edited: index)
                
//                let allAttributes = self.attributes(from: paragraphDescriptor)
                self.paragraphs[index] = paragraphDescriptor.text
//                                attributes[index] = allAttributes
                
                self.editions.append(index)
            }
        }
        
//        print("last insertion : \(self.insertions) \n last edit: \(self.editions) \n last remove: \(self.removals) ")
        print("self.blockObject: \(self.blockObjects)")
        print("self.blockObject type: \(self.blockTypes)")
    }
    
    func editBlock(from separated: SeparatedNSAttributedString, edited index: Int){
        
        let atts = separated.0
        let strs = separated.1
        let blockType = separated.2
        print("blockTypesss: \(blockType)")
        
        guard let originalType = blockObjects[index]?.blockType?.base else {return}
        
        // 블락 type이 같을때와 아닐때
        // 같을때는 edit
        // 다를때는 블락을 새로 생성해야한다.
        if originalType == blockType{
            
            // edit behavior
            // 블락의 텍스트 내용이 같다는 것은 attribute를 수정했다는 것이다.
            // 텍스트의 내용이 같다면 attribute 만 비교 1
            // 텍스트가 다르다면 attribute와 text 둘다 비교 2
            if strs == newParagraphs[index]{
                // attributed fix
                blockObjects[index]?.editAttributes(atts)
                newAttributes[index] = atts
            }else{
                // text fix
                blockObjects[index]?.editTextElement(strs,atts)
                blockObjects[index]?.editAttributes(atts)
                newParagraphs[index] = strs
            }
            
        }else{
            // create behavior
            blockObjects[index] = BlockCreateHelper.shared.createBlock_to_array(separated)
            blockTypes[index] = blockType
        }
    }
    
    
    
    func attributesArray(index: Int,
                         from paragraphDescriptor: ParagraphTextStorage.ParagraphDescriptor) -> SeparatedNSAttributedString{
        
        if !paragraphDescriptor.text.isEmpty {
            
            let (att_S, str_S, block): SeparatedNSAttributedString = paragraphDescriptor.attributedString.separatedNSAttributeString()
            
            if let blockType = paragraphDescriptor.attributedString.attribute(.blockType, at: 0, effectiveRange: nil) as? CustomBlockType.Base{
                
                return (att_S, str_S, blockType)
            }
            
            return (att_S, str_S , block)
        }
        return ([],[],.paragraph)
    }
    
    func attributes(from paragraphDescriptor: ParagraphTextStorage.ParagraphDescriptor) -> [NSAttributedString.Key: Any] {
        if !paragraphDescriptor.text.isEmpty {
            return paragraphDescriptor.attributedString.attributes(at: 0, effectiveRange: nil)
        }
        return [:]
    }
}

extension ParagraphTrackingUtility: NSTextStorageDelegate{
    
    // MARK: NSTextStorageDelegate
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        if editedMask.contains(.editedAttributes) {
            self.subAttachMentBehavior?.updateAttachedSubviews()
        }
    }
}

extension ParagraphTrackingUtility{
    func getBlockObjectObservable() -> Observable<[BlockObject?]>{
        return Observable.create{ [weak self] emit in
            guard let self = self else {return Disposables.create()}
            emit.onNext(self.getBlockObject())
            return Disposables.create()
        }
    }
    func getBlockObject() -> [BlockObject?]{
        let queue = DispatchQueue(label: "blockObject",attributes: .concurrent)
        return queue.sync{ self.blockObjects }
    }
}

extension ParagraphTrackingUtility{
    
    func makeAttributes(){
        
    }
}
