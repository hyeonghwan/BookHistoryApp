//
//  BlockValueType.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/06.
//

import Foundation



protocol BlockTextValueType: AnyObject{
    var richText: [RichTextObject] { get set }
    func getParagraphValue() -> String
    var children: [BlockObject]? { get }
}


typealias BlockValueType =  BlockTextValueType

extension BlockTextValueType{
    
    func searchChildToPreOrder(){
        
    }
    
    func getResultChild() -> [BlockValueType]{
        
        return []
    }
    
    func getFlattenChildBlockValue(){
        
        if self.children == nil{
            
        }
        
        self.children?.forEach{ object in
            
            
        }
    }
    
    func getParagraphsValues() -> [String] {
        
        let paragraph = self.richText.compactMap{ value -> String? in
            guard let text = value.text.content else { return nil }
            
            if text == "\u{fffc}"{
                return nil
            }
            return text
        }
        return paragraph
    }
    
    func getParagraphValue() -> String{
        self.richText.map{ obj in
            guard let text = obj.text.content else {return String.emptyStr() }
            return text
        }.joined()
    }
}

extension TextAndChildrenBlockValueObject: BlockValueType{
    
}

extension HeadingBlockValueObject: BlockValueType{
    var children: [BlockObject]? {
        return nil
    }
    
}

extension ToDoBlockValueObject: BlockValueType{}

//extension ChildPageBlockValueObject: BlockValueType{
//    var children: [BlockObject]? {
//        return nil  
//    }
//            
//    var richText: [RichTextObject]{
//        []
//    }
//    func getParagraphValue() -> String {
//        return self.title
//        
//    }
//}
//extension ToDoBlockValueObject: BlockValueType{
//
//
//}
//extension QuoteBlockValueObject: BlockValueType{
//
//}
//extension LinkToPageBlockValueObject: BlockValueType{
//    var children: [BlockObject]? {
//        return nil
//    }
//
//    var richText: [RichTextObject]{
//        []
//    }
//    func getParagraphValue() -> String {
//        return self.page
//
//    }
//}
//extension CalloutBlockValueObject: BlockValueType{
//}

