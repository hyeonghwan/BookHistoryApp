//
//  ToggleBlock.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import UIKit



class ToggleBlock: BlockElement {
    var richText: RichTextElement?
    let color: UIColor?
    var children: [BlockObject]?
    
    var decription: String {
        self.richText?.decription ?? "nil"
    }
    
    public init(
        richText: RichTextElement,
        children: [BlockObject]? = nil,
        color: UIColor? = nil
    ) {
        self.richText = richText
        self.children = children
        self.color = color
    }
 
    
    func editRawText(_ text: String) {
        richText?.editRawText(text)
    }
    
}

//private class ToggleChildren_PlaceHolder: BlockElement{
//    
//    let placeHolderString: String = "빈 토글입니다. 내용을 입력하시거나 드래그해서 가져와 시발련아"
//    
//    init(){
//        
//    }
//    
//    func editRawText(_ text: String){
//        fatalError("this is impossibe edit struct")
//    }
//    var decription: String {
//        self.placeHolderString
//    }
//}
