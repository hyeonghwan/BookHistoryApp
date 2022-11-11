//
//  CustomTextView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/08.
//

import UIKit


class CustomTextView: UITextView, NSTextLayoutManagerDelegate {
    
    let lineHeightMultiple: CGFloat = 2.0
    
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 12
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.layer.borderWidth = 1
        self.isScrollEnabled = false

        self.settingCusor(UIColor.black)
        
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
//        self.alwaysBounceVertical = true
//        self.isUserInteractionEnabled = true
//        self.showsVerticalScrollIndicator = true
        
        
        
        self.layoutManager.delegate = self
        self.clipsToBounds = false
        self.pasteDelegate = self
        setting()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.marking()
            
        })
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
 

        //  paste Detecting solution
        var isPastingContent = false
    
        open override func paste(_ sender: Any?) {
            isPastingContent = true
            super.paste(sender)
            
        }
    
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         print(text)
            
            if isPastingContent {
                 // do something
               
            }
            isPastingContent = false
            return isPastingContent
        }

    
    
    func setting() -> String{
        let richText = NSMutableAttributedString()

        let chunk0 = NSAttributedString(string: "But I am struggling to make a block quote / code block.\n\n")
        richText.append(chunk0)
        let name: String = "yello"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 20
        
        
        
        // Note that setting paragraphStyle.firstLineHeadIndent
        // doesn't use the background color for the first line's
        // indentation. Use a tab stop on the first line instead.
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: paragraphStyle.headIndent, options: [:])]

        let chunk1 = NSAttributedString(string: "\tSomething like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n", attributes: [
            NSAttributedString.Key.presentationIntentAttributeName : name,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.backgroundColor: UIColor.yellow
        ])
        
        richText.append(chunk1)

        let chunk2 = NSAttributedString(string: "\nIs this even possible to do strictly using AttributedStrings?")
        richText.append(chunk2)
        
        self.attributedText = richText
        self.backgroundColor = .white
        return "yellow"
    }
    
    
    func marking(){
        let text = self.text
        let range = (text! as NSString).range(of: "\tSomething like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n")
        
        print(self.text(in: self.textRangeFromNSRange(range: range) ?? UITextRange()))
    }
}

extension UITextView
   {
       func textRangeFromNSRange(range:NSRange) -> UITextRange?
       {
           let beginning = self.beginningOfDocument
         
           guard let start = self.position(from: beginning, offset: range.location),
               let end = self.position(from: start, offset: range.length) else { return nil}
           
           return self.textRange(from: start, to: end)
       }
    
    func removeColorForRange2(theRange : NSRange) {
        let pr = (self.text as NSString).paragraphRange(for: theRange)
        print("pr : \(pr)")
        print("theRange \(theRange)")
        
//        ColorBlockM\racters(in: paragraphRange, with: attString)
        
    }
    
    func removeColorForRange(theRange : NSRange) {
        print("theRange: \(theRange)")
        
        
        // textStorage index crash 방지용
        if theRange.location == self.textStorage.length {
            return
        }
        
        if self.textStorage.attribute(NSAttributedString.Key.backgroundColor,
                                   at: theRange.location,
                                      effectiveRange: nil) == nil &&
            self.textStorage.attribute(NSAttributedString.Key.paragraphStyle,
                                       at: theRange.location,
                                       effectiveRange: nil) == nil
        { print("removew return"); return }
        print("removeColorForRange")
        let paragraphRange = (self.text as NSString).paragraphRange(for: theRange)
        
        ColorBlockManager().allKey.forEach{
            self.textStorage.removeAttribute($0, range: paragraphRange)
        }
        
        guard let textRange = self.textRangeFromNSRange(range: paragraphRange) else { return }
        guard var textComponent = text(in: textRange) else {return}
        
        if textComponent.first == "\t"{
            textComponent.removeFirst()
        }
        
        let attString: NSAttributedString = NSAttributedString(string: textComponent)
        
        self.textStorage.replaceCharacters(in: paragraphRange, with: attString)
        
    }
    
    func addColorForRange(theRange: NSRange){
        
    
        let paragraphRange = (self.text as NSString).paragraphRange(for: theRange)
        
        guard let textRange = self.textRangeFromNSRange(range: paragraphRange) else { return }
        
        // textStorage index crash 방지용
        if theRange.location == self.textStorage.length {
            return
        }
        
        if self.textStorage.attribute(NSAttributedString.Key.backgroundColor,
                                   at: paragraphRange.location,
                                   effectiveRange: nil) != nil {print("add return");  return }
        
    
        guard let textComponent = text(in: textRange) else {return}
        
    
        
        let attributes = ColorBlockManager.settingColorString(UIColor.gray)
        
        
        let attString: NSAttributedString = NSAttributedString(string: "\t" + textComponent, attributes: attributes )
        
        self.textStorage.replaceCharacters(in: paragraphRange, with: attString)
        
        
        
    }
    
    
   }

extension NSRange {
    func toTextRange(textInput:UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}



extension UITextView {
    func settingCusor(_ color: UIColor){
        UITextView.appearance().tintColor = color
    }
    
    static func getFont(_ view: UITextView) -> UIFont{
        return view.font ?? UIFont.boldSystemFont(ofSize: 14)
    }
}
extension CustomTextView: UITextPasteDelegate{
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, combineItemAttributedStrings itemStrings: [NSAttributedString], for textRange: UITextRange) -> NSAttributedString {
        
        let str: NSMutableAttributedString = NSMutableAttributedString()
        itemStrings.forEach{
            str.append($0)
        }
        print(str)
        return str
    }
}

extension CustomTextView: NSLayoutManagerDelegate{
    
    func layoutManager(_ layoutManager: NSLayoutManager,
                       boundingBoxForControlGlyphAt glyphIndex: Int,
                       for textContainer: NSTextContainer,
                       proposedLineFragment proposedRect: CGRect,
                       glyphPosition: CGPoint,
                       characterIndex charIndex: Int) -> CGRect {
        return CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager,
                       shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>,
                       baselineOffset: UnsafeMutablePointer<CGFloat>,
                       in textContainer: NSTextContainer,
                       forGlyphRange glyphRange: NSRange) -> Bool {
        
        
        let fontLineHeight = self.font?.lineHeight ?? 0
        
        let lineHeight = fontLineHeight * lineHeightMultiple
        let baselineNudge = (lineHeight - fontLineHeight)
        // The following factor is a result of experimentation:
        * 0.3
        
        var rect = lineFragmentRect.pointee
        rect.size.height = lineHeight
        
        var usedRect = lineFragmentUsedRect.pointee
        usedRect.size.height = max(lineHeight, usedRect.size.height) // keep emoji sizes
        
        lineFragmentRect.pointee = rect
        lineFragmentUsedRect.pointee = usedRect
        baselineOffset.pointee = baselineOffset.pointee + baselineNudge
        
        return true
        
    }
    
    
//    func layoutManager(_ layoutManager: NSLayoutManager,
//                       lineSpacingAfterGlyphAt glyphIndex: Int,
//                       withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//        let spacing = ((self.font?.lineHeight ?? 1) * 1.6) - (self.font?.lineHeight ?? 1)
//        return spacing
//    }
}


