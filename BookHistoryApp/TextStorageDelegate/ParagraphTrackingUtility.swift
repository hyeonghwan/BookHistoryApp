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

final class ParagraphTrackingUtility: NSObject, ParagraphTextStorageDelegate{
    
    var paragraphs: [String] = []
    
    var blockTypes: [CustomBlockType.Base] = []
    
    var blockObjects: [BlockObject?] = []
    
    var attributes: [[NSAttributedString.Key: Any]] = []
    
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
    
    var presentedParagraphs: [NSAttributedString] {
        return paragraphs
            .enumerated()
            .map{ index, paragraph in
                let attribute = attributes[index]
                switch attribute.getBlockBaseType(){
                case .paragraph:
                    return NSAttributedString(string: paragraph, attributes: attribute)
                case .toggleList:
                    return addToggleWhenFirstInit(index,
                                                  self.paragraphs.count,
                                                  NSAttributedString(string: paragraph,
                                                                     attributes: attribute))
                case .textHeadSymbolList:
                    return addTextHeadSymbolWhenFirstInit(index,
                                                          self.paragraphs.count,
                                                          NSAttributedString(string: paragraph,
                                                                             attributes: attribute))
                default:
                    break
                }
                return NSAttributedString(string: paragraph, attributes: attributes[index])
            }
    }
    
    
    func textStorage(_ textStorage: ParagraphTextStorage, didChangeParagraphs changes: [ParagraphTextStorage.ParagraphChange]) {
        for change in changes {
            switch change {
            case .insertedParagraph(index: let index, descriptor: let paragraphDescriptor):
                
                if firstInit {
                    firstInit = false
                } else {
                    insertions.append(index)
                }
                
                paragraphs.insert(paragraphDescriptor.text, at: index)
                
                let allAttributes = attributes(from: paragraphDescriptor)
                attributes.insert(allAttributes, at: index)
                
                if let blockType = allAttributes[.blockType] as? CustomBlockType.Base {
                    blockTypes.insert(blockType, at: index)
                    guard let blockObj = BlockCreateHelper.shared.createBlock(blockType, paragraphDescriptor.text) else {return}
                    
                    blockObjects.insert(blockObj, at: index)
                    
                }else{
                    blockTypes.insert(.paragraph, at: index)
                    guard let blockObj = BlockCreateHelper.shared.createBlock(.paragraph,  paragraphDescriptor.text) else {return}
                    blockObjects.insert(blockObj, at: index)
                }
                
            case .removedParagraph(index: let index):
                paragraphs.remove(at: index)
                blockTypes.remove(at: index)
                blockObjects.remove(at: index)
                attributes.remove(at: index)
                removals.append(index)
                
            case .editedParagraph(index: let index, descriptor: let paragraphDescriptor):
                editObserver?.onNext(index)
                
                let allAttributes = attributes(from: paragraphDescriptor)
                
                paragraphs[index] = paragraphDescriptor.text
                attributes[index] = allAttributes
                
                editions.append(index)
                
                if let blockType = allAttributes[.blockType] as? CustomBlockType.Base {
        
                    blockTypes[index] = blockType
                    
                    guard let originalType = blockObjects[index]?.blockType?.base else {return}
        
                    if originalType == blockType{
                        let value = try? blockObjects[index]?.object?.e.getBlockValueType() as? TextAndChildrenBlockValueObject
                        blockObjects[index]?.object?.e.editRawText(paragraphDescriptor.text)
                    }else{
                        blockObjects[index] = BlockCreateHelper.shared.createBlock(blockType, paragraphDescriptor.text)
                        blockTypes[index] = blockType
                    }
                }else{
                    blockTypes[index] = .paragraph
                    
                    
                    guard let originalType = blockObjects[index]?.blockType else {return}
                    
                    if originalType.base == .paragraph{
                        blockObjects[index]?.object?.e.editRawText(paragraphDescriptor.text)
                        print("is editRawText")
                    }else{
                        blockObjects[index] = BlockCreateHelper.shared.createBlock(.paragraph, paragraphDescriptor.text)
                        print("is editRawText not")
                    }
                }
                
            }
        }
        
        
        
        changeFinishObserver?.onNext(())
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
            emit.onNext(self.blockObjects)
            return Disposables.create()
        }
    }
    func getBlockObject() -> [BlockObject?]{
        return self.blockObjects
    }
}

extension ParagraphTrackingUtility{
    
    func makeAttributes(){
        
    }
}
