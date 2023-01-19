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

final class ParagraphTrackingUtility: NSObject, ParagraphTextStorageDelegate{
    
    var paragraphs: [String] = []
    
    var blocks: [BlockType] = []
    
    var blockObject: [BlockObject?] = []
    
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
        paragraphs.map{ $0.attributedPresentation }
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
                
                if let blockType = allAttributes[.blockType] as? BlockType {
                    blocks.insert(blockType, at: index)
                    guard let blockObj = BlockCreateHelper.shared.createBlock(blockType, paragraphDescriptor.text) else {return}
                    blockObject.insert(blockObj, at: index)
                    
                }else{
                    blocks.insert(.paragraph, at: index)
                    guard let blockObj = BlockCreateHelper.shared.createBlock(.paragraph,  paragraphDescriptor.text) else {return}
                    blockObject.insert(blockObj, at: index)
                }
                
            case .removedParagraph(index: let index):
                paragraphs.remove(at: index)
                blocks.remove(at: index)
                blockObject.remove(at: index)
                attributes.remove(at: index)
                removals.append(index)
                
            case .editedParagraph(index: let index, descriptor: let paragraphDescriptor):
                editObserver?.onNext(index)
                
                let allAttributes = attributes(from: paragraphDescriptor)
                
                paragraphs[index] = paragraphDescriptor.text
                attributes[index] = allAttributes
                
                editions.append(index)
                
                if let blockType = allAttributes[.blockType] as? BlockType {
                    
                    blocks[index] = blockType
                    
                    guard let originalType = blockObject[index]?.blockType else {return}
                    
                    if originalType == blockType{
                        blockObject[index]?.object?.editRawText(paragraphDescriptor.text)
                    }else{
                        blockObject[index] = BlockCreateHelper.shared.createBlock(blockType, paragraphDescriptor.text)
                    }
                }else{
                    blocks[index] = .paragraph
                    
                    
                    guard let originalType = blockObject[index]?.blockType else {return}
                    
                    if originalType == .paragraph{
                        blockObject[index]?.object?.editRawText(paragraphDescriptor.text)
                        print("is editRawText")
                    }else{
                        blockObject[index] = BlockCreateHelper.shared.createBlock(.paragraph, paragraphDescriptor.text)
                        print("is editRawText not")
                    }
                    print("is not block Type when editeParagraph util")
                }
            }
        }
        changeFinishObserver?.onNext(())
        
        print("self.paragraph: \(self.paragraphs)")
        print("self.blocks : \(self.blocks)")
        
        self.blockObject.forEach{ object in
            print("objec,Type: \(object?.blockType)")
            print("object?.object?.decription : \(object?.object?.decription)")
        }
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
        print("em2 storage: \(editedMask)")
        print("\n")
        if editedMask.contains(.editedAttributes) {
            self.subAttachMentBehavior?.updateAttachedSubviews()
        }
        
    }
    
}
