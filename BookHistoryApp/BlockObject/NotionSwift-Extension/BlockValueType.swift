//
//  BlockValueType.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/06.
//

import Foundation



protocol BlockValueType{
    var richText: [RichTextObject] { get }
    func getParagraphValue() -> String
}
extension BlockValueType{
    
    func getParagraphsValues() -> [String] {
        self.richText.map{ obj in
            guard let text = obj.text.content else {return String.emptyStr() }
            return text
        }
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
}

extension ChildPageBlockValueObject: BlockValueType{
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
    var richText: [RichTextObject]{
        []
    }
    func getParagraphValue() -> String {
        return self.page
        
    }
}
extension CalloutBlockValueObject: BlockValueType{
  
}

