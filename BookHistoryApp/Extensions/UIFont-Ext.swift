//
//  UIFont-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/06.
//

import UIKit


extension UIFont {
    static var appleFontFamiliyName = "AppleSDGothicNeo"
    
    enum appleSDGothicNeo: String {
        
        case thin = "AppleSDGothicNeo-Thin"
        case light = "AppleSDGothicNeo-Light"
        case regular = "AppleSDGothicNeo-Regular"
        case medium = "AppleSDGothicNeo-Medium"
        case semiBold = "AppleSDGothicNeo-SemiBold"
        case bold = "AppleSDGothicNeo-Bold"
        
        public func font(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
    
    static func preferredFont(block type: CustomBlockType.Base) -> UIFont{
        
        if type == .title1{
            return UIFont.preferredFont(forTextStyle: .title1, familyName: appleFontFamiliyName)
        }
        if type == .title3{
            return UIFont.preferredFont(forTextStyle: .title3, familyName: appleFontFamiliyName)
        }
        if type == .title2{
            return UIFont.preferredFont(forTextStyle: .title2, familyName: appleFontFamiliyName)
        }
        
        return UIFont.preferredFont(forTextStyle: .body, familyName: appleFontFamiliyName)
    }
    
    static func preferredFont(forTextStyle style: UIFont.TextStyle,familyName: String ,scaleFactor: CGFloat = 1) -> UIFont {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        //      let font = UIFont.preferredFont(forTextStyle: style)
        
        let family = fontDescriptor.withFamily(familyName)
        
        guard let newDescriptor = family.withSymbolicTraits(.traitBold) else {return UIFont.boldSystemFont(ofSize: 16)}
        
        let font = UIFont(descriptor: newDescriptor, size: newDescriptor.pointSize * scaleFactor)
        //        font.withSize(font.pointSize * scaleFactor)
        //        print("font.fontDescriptor.symbolicTraits ; \(font.fontDescriptor.symbolicTraits)")
        return font
    }
    
    var isBold: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    func setBold() -> UIFont
    {
        var fontDescriptorVar: UIFontDescriptor
        if(isBold){
            return self
        }
        else
        {
            fontDescriptorVar = fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFontDescriptor()
            
            
        }
        return UIFont(descriptor: fontDescriptorVar, size: self.pointSize)
    }
  
    
    func setBoldItalic() -> UIFont
    {
        let font = self.setItalic()
        var symTraits = font.fontDescriptor.symbolicTraits
        symTraits.insert(.traitBold)
        
        let fontDescriptorVar: UIFontDescriptor = font.fontDescriptor.withSymbolicTraits(symTraits) ?? UIFontDescriptor()

        return UIFont(descriptor: fontDescriptorVar, size: self.pointSize)
    }
    
    func setItalic() -> UIFont{
        
        var fontDescriptorVar: UIFontDescriptor
        if(isItalic) {
            return self
        }
        else
        {
            let matrix = CGAffineTransform(a: 1,
                                           b: 0,
                                           c: CGFloat(tanf(12 * 3.141592653589793 / 180 )),
                                           d: 1,
                                           tx: 0,
                                           ty: 0)
            let desc = UIFontDescriptor.init(name: "AppleSDGothicNeo-Thin",
                                                     matrix: matrix)
            
            fontDescriptorVar = desc
        }
      
        return UIFont(descriptor: fontDescriptorVar, size: self.pointSize)
    }
    
//    func setItalic()-> UIFont
//    {
//        var fontDescriptorVar: UIFontDescriptor
//        if(isItalic) {
//            return self
//        }
//        else
//        {
//            fontDescriptorVar = fontDescriptor.withSymbolicTraits(.traitItalic) ?? UIFontDescriptor()
//        }
//        return UIFont(descriptor: fontDescriptorVar, size: 0)
//    }
}
