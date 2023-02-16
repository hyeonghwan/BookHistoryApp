//
//  BlockValueType.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/06.
//

import Foundation



protocol BlockTextValueType{
    var richText: [RichTextObject] { get }
    func getParagraphValue() -> String
    var children: [BlockObject]? { get }
}


typealias BlockValueType =  BlockTextValueType

extension BlockTextValueType{
    
    func getParagraphsValues() -> [String] {
        
        var t = self.richText.compactMap{ value -> String? in
            guard let text = value.text.content else { return nil }
            if text == "\u{fffc}"{
                return nil
            }
            return text
        }
        
        
        if t.last == "\n"{
            t.removeLast()
        }
        return t
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

extension ChildPageBlockValueObject: BlockValueType{
    var children: [BlockObject]? {
        return nil  
    }
            
    var richText: [RichTextObject]{
        []
    }
    func getParagraphValue() -> String {
        return self.title
        
    }
}
extension ToDoBlockValueObject: BlockValueType{
    
 
}
extension QuoteBlockValueObject: BlockValueType{

}
extension LinkToPageBlockValueObject: BlockValueType{
    var children: [BlockObject]? {
        return nil
    }
    
    var richText: [RichTextObject]{
        []
    }
    func getParagraphValue() -> String {
        return self.page
        
    }
}
extension CalloutBlockValueObject: BlockValueType{
}

