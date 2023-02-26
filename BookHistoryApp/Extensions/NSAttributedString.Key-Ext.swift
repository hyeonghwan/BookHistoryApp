//
//  NSAttributedString.Key-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/05.
//

import UIKit

extension UIColor{
    static let placeHolderColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
}
extension NSAttributedString.Key {
    static let comment = NSAttributedString.Key("comment")
    
    static let title_one = NSAttributedString.Key("Title1")
    static let title_two = NSAttributedString.Key("Title2")
    static let title_three = NSAttributedString.Key("Title3")
    
    static let blockType = NSAttributedString.Key("BlockType")
    
    
    static let defaultParagraphAttribute: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.paragraph,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.label,
     .paragraphStyle : NSParagraphStyle.defaultParagraphStyle()]
    
    
    static let placeHolderColorAttributeDic: [NSAttributedString.Key : Any] = [ .foregroundColor : UIColor.placeHolderColor ]
    
    static let placeHolderColorAttribute: (NSAttributedString.Key,UIColor) =  (.foregroundColor, UIColor.placeHolderColor)
    
    
    static let textHeadSymbolListPlaceHolderAttributes: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.textHeadSymbolList,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.placeHolderColor,
     .paragraphStyle : NSParagraphStyle.nsAttachmentHeadIndentParagraphStyle()]
    
    
    static let togglePlaceHolderAttributes: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.toggleList,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.placeHolderColor,
     .paragraphStyle : NSParagraphStyle.nsAttachmentHeadIndentParagraphStyle()]
    
    static let todoPlaceHolderAttributes: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.todoList,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.placeHolderColor,
     .paragraphStyle : NSParagraphStyle.nsAttachmentHeadIndentParagraphStyle()]
    
    
    static let togglePlaceHolderChildAttributes: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.paragraph,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.placeHolderColor,
     .paragraphStyle : NSParagraphStyle.toggleChildIndentParagraphStyle()]
    
    
    static let toggleAttributes: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.toggleList,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.label,
     .paragraphStyle : NSParagraphStyle.nsAttachmentHeadIndentParagraphStyle()]
    
    static let textHeadSymbolListAttributes: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.textHeadSymbolList,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.label,
     .paragraphStyle : NSParagraphStyle.nsAttachmentHeadIndentParagraphStyle()]
    
    static let todoListAttributes: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.todoList,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.label,
     .paragraphStyle : NSParagraphStyle.nsAttachmentHeadIndentParagraphStyle()]
    
    
    static let paragrphStyleInTogle: [NSAttributedString.Key : Any] =
    [NSAttributedString.Key.blockType : CustomBlockType.Base.paragraph,
     NSAttributedString.Key.backgroundColor : UIColor.clear,
     NSAttributedString.Key.font : UIFont.appleSDGothicNeo.regular.font(size: 16),
     NSAttributedString.Key.foregroundColor : UIColor.label,
     .paragraphStyle : NSParagraphStyle.toggleChildIndentParagraphStyle()]
    
    

    
    static func getPlaceTitleAttribues(_ fontStyle: UIFont.TextStyle) -> [NSAttributedString.Key : Any]{
        
        let font = UIFont.preferredFont(forTextStyle: fontStyle, familyName: UIFont.appleFontFamiliyName)
        
        var result : [NSAttributedString.Key : Any] = [.font : font,
                                                       .foregroundColor : UIColor.placeHolderColor,
                                                       .paragraphStyle : NSParagraphStyle.titleParagraphStyle()]
        switch fontStyle{
        case .title1:
            result[.blockType] = CustomBlockType.Base.title1
        case .title2:
            result[.blockType] = CustomBlockType.Base.title2
        case .title3:
            result[.blockType] = CustomBlockType.Base.title3
        default:
            return [:]
        }
        return result
    }
    
    static func getTitleAttributes(block type: CustomBlockType.Base, font: UIFont) -> [NSAttributedString.Key : Any]{
        return [NSAttributedString.Key.blockType : type,
                .font : font,
                NSAttributedString.Key.foregroundColor : UIColor.label,
                .paragraphStyle : NSParagraphStyle.titleParagraphStyle()]
    }
}

extension NSAttributedString{
//    static var titleAttributeString = NSAttributedString(string: "제목을 입력해주세요",
//                                                         attributes: NSAttributedString.Key.defaultAttribute)
    static func getNumberTitleAttStr(_ font: UIFont.TextStyle) -> NSAttributedString {
        if font == .title1{
            return NSAttributedString.title1_placeHolderString
        }else if font == .title2{
            return NSAttributedString.title2_placeHolderString
        }else if font == .title3{
            return NSAttributedString.title3_placeHolderString
        }else{
            return NSAttributedString(string: String.emptyStr())
        }
    }
    
    
    static func getCustomBlockTypeAttributes(block type: CustomBlockType.Base) -> [NSAttributedString.Key : Any]{
        switch type {
        case .paragraph:
            return NSAttributedString.Key.defaultParagraphAttribute
        case .page:
            break
        case .todoList:
            return NSAttributedString.Key.todoListAttributes
        case .title1:
            return NSAttributedString.Key.getTitleAttributes(block: .title1, font: UIFont.preferredFont(block: .title1))
        case .title2:
            return NSAttributedString.Key.getTitleAttributes(block: .title2, font: UIFont.preferredFont(block: .title2))
        case .title3:
            return NSAttributedString.Key.getTitleAttributes(block: .title3, font: UIFont.preferredFont(block: .title3))
        case .graph:
            break
        case .textHeadSymbolList:
            return NSAttributedString.Key.textHeadSymbolListAttributes
        case .numberList:
            break
        case .toggleList:
            return NSAttributedString.Key.toggleAttributes
        case .quotation:
            break
        case .separatorLine:
            break
        case .pageLink:
            break
        case .callOut:
            break
        case .none:
            break
        }
        
        return [:]
        
    }
    
    static var title1_placeHolderString = NSAttributedString(string: "제목없음1",
                                                            attributes: NSAttributedString.Key.getPlaceTitleAttribues(.title1))
    static var title2_placeHolderString = NSAttributedString(string: "제목없음2",
                                                            attributes: NSAttributedString.Key.getPlaceTitleAttribues(.title2))
    static var title3_placeHolderString = NSAttributedString(string: "제목없음3",
                                                            attributes: NSAttributedString.Key.getPlaceTitleAttribues(.title3))
    
    static var toggle_placeHolderString = NSAttributedString(string: "토글",
                                                             attributes: NSAttributedString.Key.togglePlaceHolderAttributes)
    
    static var textHeadSymbolList_placeHolderString = NSAttributedString(string: "리스트",
                                                             attributes: NSAttributedString.Key.textHeadSymbolListPlaceHolderAttributes)
    static var todo_PlaceHolderString = NSAttributedString(string: "할 일",
                                                           attributes: NSAttributedString.Key.todoPlaceHolderAttributes)
    
    
    static var toggle_ChildPlaceHolderString = NSAttributedString(string: "빈 토글입니다. 내용을 입력하시거나 드래그해서 가져와 시발련아",
                                                                  attributes: NSAttributedString.Key.togglePlaceHolderChildAttributes)
    
    static var paragraphNewLine: NSAttributedString{
        return NSAttributedString(string: String.newLineString(), attributes: NSAttributedString.Key.defaultParagraphAttribute)
    }
    
    static var doubleParagraphNewLine: NSAttributedString{
        return NSAttributedString(string: "\(String.newLineString())\(String.newLineString())",
                                  attributes: NSAttributedString.Key.defaultParagraphAttribute)
    }
    
    
    
    
    var allAttributes: [NSAttributedString.Key : Any]{
        get{
            self.attributes(at: self.range.location, effectiveRange: nil)
        }
    }
  
    var separatedAttributed: [[NSAttributedString.Key : Any]] {
        return separteParagraphAttributes()
    }
    
    func separatedNSAttributeString() -> SeparatedNSAttributedString{
        var (att_S, str_S, _): SeparatedNSAttributedString = ([],[],CustomBlockType.Base.none)
        if self.string.isNewLine(){
            return ([NSAttributedString.Key.defaultParagraphAttribute], [String.newLineString()], .paragraph)
        }
        self.enumerateAttributes(in: self.range,
                                 options: .longestEffectiveRangeNotRequired){
            attributes, subRange, pointer in
            
            let subText = self.attributedSubstring(from: subRange)
            
            if subText.string != String.newLineString(){
                att_S.append(attributes)
                str_S.append(subText.string)
                
            }else{
                if !str_S.isEmpty{
                    var lastString = str_S.removeLast()
                    lastString.append(String.newLineString())
                    str_S.append(lastString)
                }
                pointer.pointee = true
            }
        }
        return (att_S, str_S, .paragraph)
    }
    
    
    func separteParagraphAttributes() -> [[NSAttributedString.Key : Any]]{
        var resultAttributes: [[NSAttributedString.Key : Any]] = []
        self.enumerateAttributes(in: self.range,
                                 options: .longestEffectiveRangeNotRequired){
            attributes, subRange, pointer in
            resultAttributes.append(attributes)
        }
        return resultAttributes
    }
}

///* let 2nd tuple be an array of tuples itself */
//extension NSAttributedString {
//    func getAttributes() -> [(NSRange, [(String, AnyObject)])] {
//        var attributesOverRanges : [(NSRange, [(String, AnyObject)])] = []
//        var rng = NSRange()
//        var idx = 0
//
//        while idx < self.length {
//            let foo = self.attributes(at: idx, effectiveRange: &rng)
//            var attributes : [(String, AnyObject)] = []
//
//            for (k, v) in foo { attributes.append(k, v) }
//            attributesOverRanges.append((rng, attributes))
//
//            idx = max(idx + 1, rng.toRange()?.endIndex ?? 0)
//        }
//        return attributesOverRanges
//    }
//}
//
