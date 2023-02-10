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


typealias SeparatedNSAttributedString = ([[NSAttributedString.Key : Any]], [String], CustomBlockType.Base)

enum BlockDirection{
    case up
    case down
}

protocol BlockTrackingToCoreDataConvertible{
    
}

final class ParagraphTrackingUtility: NSObject, ParagraphTextStorageDelegate{
    
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
    
    weak var paragrphTextView: UITextView?
    
    weak var subAttachMentBehavior: SubviewAttachingTextViewBehavior?
    
    
    private var firstInit = true
    
    var ranges: [NSRange] {
        var location = 0
        
        return paragraphs.map { string -> NSRange in
            let range = NSRange(location: location, length: string.length)
            location = range.max
            return range
        }
    }
    
    var newPresentedParagraphs: [NSAttributedString]{
        return self.newParagraphs.enumerated().map{ paragraph_index,paragraphs_d in
            var attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: ""))
            paragraphs_d.enumerated().forEach{ index_element, string in
                let attributes = newAttributes[paragraph_index][index_element]
                attributedString.append(NSAttributedString(string: string, attributes: attributes))
            }
            return attributedString
        }
    }
    
    
    var presentedParagraphs: [NSAttributedString] {
        print("newPresentedParagraphs : \(newPresentedParagraphs)")
        return newPresentedParagraphs
        //        return paragraphs
        //            .enumerated()
        //            .map{ index, paragraph in
        //                let attribute = attributes[index]
        //                switch attribute.getBlockBaseType(){
        //                case .paragraph:
        //                    return NSAttributedString(string: paragraph, attributes: attribute)
        //                case .toggleList:
        //                    return addToggleWhenFirstInit(index,
        //                                                  self.paragraphs.count,
        //                                                  NSAttributedString(string: paragraph,
        //                                                                     attributes: attribute))
        //                case .textHeadSymbolList:
        //                    return addTextHeadSymbolWhenFirstInit(index,
        //                                                          self.paragraphs.count,
        //                                                          NSAttributedString(string: paragraph,
        //                                                                             attributes: attribute))
        //                default:
        //                    break
        //                }
        //                return NSAttributedString(string: paragraph, attributes: attributes[index])
        //            }
    }
    
    
    func textStorage(_ textStorage: ParagraphTextStorage, didChangeParagraphs changes: [ParagraphTextStorage.ParagraphChange]) {
        let serialQueue = DispatchQueue(label: "serial")
        let group = DispatchGroup()
        defer{
            print("didChangeParagraphs : defer")
        }
        print("serialQueue: task : 1")
        serialQueue.async(group: group){ [weak self] in
        for change in changes {
            print("serialQueue: task : 2")
            
                print(" serialQueue: task: \(Thread.isMainThread)")
                guard let self = self else {return}
            
                switch change {
                case .insertedParagraph(index: let index, descriptor: let paragraphDescriptor):
                    
                    if self.firstInit {
                        self.firstInit = false
                    } else {
                        self.insertions.append(index)
                    }
                    
                    let separatedNSAttString = self.attributesArray(from: paragraphDescriptor)
                    self.newParagraphs.insert(separatedNSAttString.1, at: index)
                    self.newAttributes.insert(separatedNSAttString.0, at: index)
                    
                    let blockType = separatedNSAttString.2
                    self.blockTypes.insert( blockType, at: index)
                    
                    
                    guard let blockObj = BlockCreateHelper.shared.createBlock_to_array(separatedNSAttString) else {return}
                    self.blockObjects.insert(blockObj, at: index)
                    
                    
                    let allAttributes = self.attributes(from: paragraphDescriptor)
                    self.paragraphs.insert(paragraphDescriptor.text, at: index)
                    //                attributes.insert(allAttributes, at: index)
                    
                    
                    
                case .removedParagraph(index: let index):
                    self.newParagraphs.remove(at: index)
                    self.newAttributes.remove(at: index)
                    
                    self.paragraphs.remove(at: index)
                    self.blockTypes.remove(at: index)
                    self.blockObjects.remove(at: index)
                    //              self.  attributes.remove(at: index)
                    self.removals.append(index)
                    
                case .editedParagraph(index: let index, descriptor: let paragraphDescriptor):
                    self.editObserver?.onNext(index)
                    
                    // test separate
                    let separatedNSAttString = self.attributesArray(from: paragraphDescriptor)
                    
                    self.editBlock(from: separatedNSAttString, edited: index)
                    
                    let allAttributes = self.attributes(from: paragraphDescriptor)
                    self.paragraphs[index] = paragraphDescriptor.text
                    //                attributes[index] = allAttributes
                    print("serialQueue: task : 3")
                    self.editions.append(index)
                    
                }
            }
        }
        print("newParagrpha : \(newParagraphs.count)")
        print("serialQueue: task : 4")
        group.notify(queue: serialQueue) { [weak self] in
            guard let self = self else {return}
            print("serialQueue: task end")
        }
        print("hello")
        
        
        
        
        
        changeFinishObserver?.onNext(())
    }
    
    func editBlock(from separated: SeparatedNSAttributedString, edited index: Int){
        
        let atts = separated.0
        let strs = separated.1
        let blockType = separated.2
        
        
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
                newParagraphs[index] = strs
            }
            
            
            
        }else{
            // create behavior
            blockObjects[index] = BlockCreateHelper.shared.createBlock_to_array(separated)
            blockTypes[index] = blockType
        }
    }
    
    
    func attributesArray(from paragraphDescriptor: ParagraphTextStorage.ParagraphDescriptor) -> SeparatedNSAttributedString{
        if !paragraphDescriptor.text.isEmpty {
            print(" serialQueue: task attributesArray: \(Thread.isMainThread)")
            var (att_S, str_S, _): SeparatedNSAttributedString = ([],[],CustomBlockType.Base.none)
            
            paragraphDescriptor.attributedString.enumerateAttributes(in: paragraphDescriptor.attributedString.range,
                                                                     options: .longestEffectiveRangeNotRequired){
                attributes, subRange, pointer in
                
                let subText = paragraphDescriptor.attributedString.attributedSubstring(from: subRange)
                
                if subText.string != String.newLineString(){
                    att_S.append(attributes)
                    str_S.append(subText.string)
                    
                }else{
                    pointer.pointee = true
                }
            }
            
            if let blockType = paragraphDescriptor.attributedString.attribute(.blockType, at: 0, effectiveRange: nil) as? CustomBlockType.Base{
                return (att_S, str_S, blockType)
            }
            
            return (att_S, str_S , .paragraph)
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
        print(" serialQueue: task textStorage: \(Thread.isMainThread)")
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



//old logic
//                if let blockType = allAttributes[.blockType] as? CustomBlockType.Base {
//                    blockTypes.insert(blockType, at: index)
//                    guard let blockObj = BlockCreateHelper.shared.createBlock(blockType, paragraphDescriptor.text) else {return}
//                    blockObjects.insert(blockObj, at: index)
//
//                }else{
//                    blockTypes.insert(.paragraph, at: index)
//                    guard let blockObj = BlockCreateHelper.shared.createBlock(.paragraph,  paragraphDescriptor.text) else {return}
//                    blockObjects.insert(blockObj, at: index)
//                }


//                old Logic
//                if let blockType = allAttributes[.blockType] as? CustomBlockType.Base {
//
//                    blockTypes[index] = blockType
//
//                    guard let originalType = blockObjects[index]?.blockType?.base else {return}
//
//                    if originalType == blockType{
//                        let value = try? blockObjects[index]?.object?.e.getBlockValueType() as? TextAndChildrenBlockValueObject
//                        blockObjects[index]?.object?.e.editRawText(paragraphDescriptor.text)
//                    }else{
//                        blockObjects[index] = BlockCreateHelper.shared.createBlock(blockType, paragraphDescriptor.text)
//                        blockTypes[index] = blockType
//                    }
//                }else{
//                    blockTypes[index] = .paragraph
//
//
//                    guard let originalType = blockObjects[index]?.blockType else {return}
//
//                    if originalType.base == .paragraph{
//                        blockObjects[index]?.object?.e.editRawText(paragraphDescriptor.text)
//                        print("is editRawText")
//                    }else{
//                        blockObjects[index] = BlockCreateHelper.shared.createBlock(.paragraph, paragraphDescriptor.text)
//                        print("is editRawText not")
//                    }
//                }
//switch change {
//case .insertedParagraph(index: let index, descriptor: let paragraphDescriptor):
//
//    if firstInit {
//        firstInit = false
//    } else {
//        insertions.append(index)
//    }
//
//    let separatedNSAttString = attributesArray(from: paragraphDescriptor)
//    newParagraphs.insert(separatedNSAttString.1, at: index)
//    newAttributes.insert(separatedNSAttString.0, at: index)
//
//    let blockType = separatedNSAttString.2
//    blockTypes.insert( blockType, at: index)
//
//
//    guard let blockObj = BlockCreateHelper.shared.createBlock_to_array(separatedNSAttString) else {return}
//    blockObjects.insert(blockObj, at: index)
//
//
//    let allAttributes = attributes(from: paragraphDescriptor)
//    paragraphs.insert(paragraphDescriptor.text, at: index)
////                attributes.insert(allAttributes, at: index)
//
//
//
//case .removedParagraph(index: let index):
//    newParagraphs.remove(at: index)
//    newAttributes.remove(at: index)
//
//    paragraphs.remove(at: index)
//    blockTypes.remove(at: index)
//    blockObjects.remove(at: index)
////                attributes.remove(at: index)
//    removals.append(index)
//
//case .editedParagraph(index: let index, descriptor: let paragraphDescriptor):
//    editObserver?.onNext(index)
//
//    // test separate
//    let separatedNSAttString = attributesArray(from: paragraphDescriptor)
//
//    editBlock(from: separatedNSAttString, edited: index)
//
//    let allAttributes = attributes(from: paragraphDescriptor)
//    paragraphs[index] = paragraphDescriptor.text
////                attributes[index] = allAttributes
//
//    editions.append(index)
//
//}
//}
