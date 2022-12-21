//
//  CustomTextView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/08.
//

import UIKit


class CustomTextView: UITextView {
    
    
    let lineHeightMultiple: CGFloat = 1.3
    
    
    private var textHolder: String? {
        didSet{
        }
    }
    
    var spacing: CGFloat = 3
    var bgColor: UIColor = .systemCyan
    
    
    override var attributedText: NSAttributedString! {
        didSet {
            self.textHolder = self.attributedText.string
            self.setNeedsDisplay()
        }
    }
    

    override var text: String! {
        didSet {
            self.textHolder = self.attributedText.string
            self.setNeedsDisplay()
        }
    }

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)

        configure()
//        testSetting()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    
    private func configure() {
        self.layoutManager.delegate = self
        
        self.clipsToBounds = false
        
        self.pasteDelegate = self
        
        self.backgroundColor = .clear
        
        self.layer.borderColor = UIColor.red.cgColor
        
        self.layer.cornerRadius = 12
        
        self.font = UIFont.boldSystemFont(ofSize: 30)
        
        self.layer.borderWidth = 1
        
        self.isScrollEnabled = false
        
        self.settingCusor(UIColor.black)
        
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let txt = self.text else { return }
        
        let textRange = NSRange(location: 0, length: txt.count)
        print("txt : \(txt)")
        print("textRange: \(textRange)")
        print("------draw-------")
        
        self.setBackGround(textRange)
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

    
    
    func testSetting(){
        let richText = NSMutableAttributedString()

        
        var paragraphStyle = NSParagraphStyle()
//        paragraphStyle.alignment = .center
        
        let chunk0 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n",
                                        attributes: [
            NSAttributedString.Key.presentationIntentAttributeName : Color.systemCyan,
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
        ])
        richText.append(chunk0)

        self.attributedText = richText
        self.backgroundColor = .white
    }
    
    func testSetting2(){
        
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



extension CustomTextView: UITextPasteDelegate{
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, combineItemAttributedStrings itemStrings: [NSAttributedString], for textRange: UITextRange) -> NSAttributedString {

        let str: NSMutableAttributedString = NSMutableAttributedString()
        itemStrings.forEach{
            str.append($0)
        }
        return str
    }
}



