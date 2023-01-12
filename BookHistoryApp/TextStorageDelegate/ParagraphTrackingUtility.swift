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
    var attributes: [[NSAttributedString.Key: Any]] = []
    
    var insertions: [Int] = []{
        didSet{
            print("Util insertions: \(self.insertions)")
            print("self.paragraph: \(self.paragraphs)")
        }
    }
    var removals: [Int] = []{
        didSet{
            print("Util removals: \(self.removals)")
        }
    }
    var editions: [Int] = []{
        didSet{
            print("Util editions: \(self.editions)")
            print("self.paragraph: \(self.paragraphs)")
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
    
    weak var subAttachMentBehavior: SubviewAttachingTextViewBehavior?
    
    var publish = PublishSubject<Void>()
    var changeFinish: AnyObserver<Void>?
    
    
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
    
    
    func exChangeBlock(_ direction: BlockDirection,_ current: NSRange){
        // replaceCharacter 호출
        // -> textStorage 종료후 (DispatchQueue.main.async)
        // -> replaceCharacter 호출
        guard let paragraphIndex = self.ranges.firstIndex(where: { $0 == current } ) else {return}
        
        switch direction{
        case .down:
            moveDownBlock(paragraphIndex, 1)
        case .up:
            moveUpBlock(paragraphIndex, -1)
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
                attributes.insert(attributes(from: paragraphDescriptor), at: index)
                
            case .removedParagraph(index: let index):
                paragraphs.remove(at: index)
                attributes.remove(at: index)
                removals.append(index)
                
            case .editedParagraph(index: let index, descriptor: let paragraphDescriptor):
                paragraphs[index] = paragraphDescriptor.text
                attributes[index] = attributes(from: paragraphDescriptor)
                editions.append(index)
            }
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

private extension ParagraphTrackingUtility{
    private func moveUpBlock(_ paragraphIndex: Int, _ offset: Int){
        if paragraphIndex > 1{
            let moveUpBlockIndex = paragraphIndex + offset
            
            var currentParagraphString = self.paragraphs[paragraphIndex]
            let currentAttributes = self.attributes[paragraphIndex]
            let upRange = ranges[moveUpBlockIndex]
            
            if currentParagraphString.endsWithNewline{
                currentParagraphString.removeLast()
            }
            
            let currentAttributeString = NSAttributedString(string: currentParagraphString,
                                                            attributes: currentAttributes)
            
            var upParagraphString = self.paragraphs[moveUpBlockIndex]
            let upAttributes = self.attributes[moveUpBlockIndex]
            let currentRange = ranges[paragraphIndex]
            
            
            if upParagraphString.endsWithNewline{
                upParagraphString.removeLast()
            }
            
            var newCurrentRange: NSRange = NSRange(location: currentRange.location, length: currentRange.length - 1)
            let newUpRange: NSRange = NSRange(location: upRange.location, length: upRange.length - 1)
            
            if paragraphIndex == ranges.count - 1{
                newCurrentRange = NSRange(location: currentRange.location, length: currentRange.length)
            }
            
            let upAttributeString = NSAttributedString(string: upParagraphString,
                                                       attributes: upAttributes)
            
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.replaceCharacters(in: newCurrentRange, with: upAttributeString)
            self.paragraphStorage?.endEditing()
            
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.replaceCharacters(in: newUpRange, with: currentAttributeString)
            self.paragraphStorage?.endEditing()
            
            let caretPositionRange = self.ranges[moveUpBlockIndex]
            self.subAttachMentBehavior?.textView?.selectedRange = NSRange(location: caretPositionRange.max - 1, length: 0)
            
        }else {
            return
        }
    }
    
    private func moveDownBlock(_ paragraphIndex: Int,_ offset: Int){
        if paragraphIndex < ranges.count - 1{
            let moveDownBlockIndex = paragraphIndex + offset
            
            var currentParagraphString = self.paragraphs[paragraphIndex]
            
            if currentParagraphString.endsWithNewline{
                currentParagraphString.removeLast()
            }
            
            let currentAttributes = self.attributes[paragraphIndex]
            let downRange = ranges[moveDownBlockIndex]
            
            let currentAttributeString = NSAttributedString(string: currentParagraphString,
                                                            attributes: currentAttributes)
            
            var downParagraphString = self.paragraphs[moveDownBlockIndex]
            let downAttributes = self.attributes[moveDownBlockIndex]
            let currentRange = ranges[paragraphIndex]
            
            
            if downParagraphString.endsWithNewline{
                downParagraphString.removeLast()
            }
        
            var newCurrentRange: NSRange = NSRange(location: currentRange.location, length: currentRange.length - 1)
            var newdownRange: NSRange = NSRange(location: downRange.location, length: downRange.length - 1)
            
            if paragraphIndex == ranges.count - 2{
                newCurrentRange = NSRange(location: currentRange.location, length: currentRange.length - 1)
                newdownRange = NSRange(location: downRange.location, length: downRange.length )
            }
            
            self.paragraphStorage?.beginEditing()
            self.paragraphStorage?.replaceCharacters(in: newdownRange ,
                                              with: currentAttributeString)
            self.paragraphStorage?.endEditing()
        
          
            let downAttributeString = NSAttributedString(string: downParagraphString,
                                                         attributes: downAttributes)
         
            self.paragraphStorage?.beginEditing()
            
            self.paragraphStorage?.replaceCharacters(in: newCurrentRange,
                                              with: downAttributeString)
            self.paragraphStorage?.endEditing()
            
            let caretPositionRange = self.ranges[moveDownBlockIndex]
            self.subAttachMentBehavior?.textView?.selectedRange = NSRange(location: caretPositionRange.max - 1, length: 0)
            
            print("self.paragraph: \(self.paragraphs)")

        }else {
            return
        }
    }
    
}

