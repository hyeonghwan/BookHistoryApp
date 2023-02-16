//
//  ParagraphTrackingUtil-RX.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/06.
//

import Foundation
import RxCocoa
import RxSwift


// ParagraphTrackingUtility -> paragraphTUtil
extension Reactive where Base: ParagraphTrackingUtility{
    
    var paragraphs: Binder<[String]>{
        return Binder(self.base) { paragraphUtil, value in
            paragraphUtil.paragraphs = value
        }
    }
    var newParagraphs: Binder<[[String]]>{
        return Binder(self.base){ paragraphUtil , value in
            paragraphUtil.newParagraphs = value
        }
    }
    
    var newAttributes: Binder<[[[NSAttributedString.Key : Any]]]>{
        return Binder(self.base){ paragraphUtil , value in
            paragraphUtil.newAttributes = value
        }
    }
    
    var blockObjects: Binder<[BlockObject]>{
        return Binder(self.base) { paragraphTUtil , blocks in
            paragraphTUtil.blockObjects = blocks
            print("blocks : \(blocks)")
            onBlockType(blocks)
            onParagraph(blocks)
            onAttributes(blocks)
            print("-dsfasdf")
            print(self.paragraphs)
        }
    }
    
    var blockTypes: Binder<[CustomBlockType.Base]>{
        return Binder(self.base) { paragraphTUtil , value in
            paragraphTUtil.blockTypes = value
        }
    }
    
    var attributes: Binder<[[NSAttributedString.Key : Any]]>{
        return Binder(self.base){ paragraphTUtil , value in
            paragraphTUtil.attributes = value
        }
    }
    
    private func onAttributes(_ blocks: [BlockObject]){
        var attributeArray: [[[NSAttributedString.Key : Any]]] = []
        blocks.forEach{ block in
//            block.getObjectAttributes()
            attributeArray += block.getAllObejctAttributes()
        }
        
        attributeArray.forEach{ value in
            print("value[0][.blockType] : \(value[0][.blockType])")
            print("value[0][.blockType] : \((value[0][.paragraphStyle] as! NSParagraphStyle).headIndent)")
            print("--------------------------------------------")
        }
        
        self.newAttributes.onNext(attributeArray)
    }
    
    private func onBlockType(_ blocks: [BlockObject]){
        let types = blocks.compactMap{ $0.object?.e.base }
        blockTypes.onNext(types)
    }
    
    
    private func onParagraph(_ blocks: [BlockObject]){
        print("\(#function) , \(#line)")
        do{
            let paragraphsFromBlock
            =
            try blocks
                .map{ block in  try block.object?.e.getBlockValueType()}
                .compactMap{ blockType in blockType?.getParagraphsValues() }
            
            print("paragraphsFromBlock: \(paragraphsFromBlock)")

            let t = paragraphsFromBlock.map{ sequence in
                return sequence.joined()
            }
            print("paragraphsFromBlock.map | \(t)")
            
            self.paragraphs.onNext(t)
            self.newParagraphs.onNext(paragraphsFromBlock)
        }catch{
            print("\(#function) , \(#line)")
            print("error: \(error)")
            fatalError("\(error)")
        }
    }
    
    
}
