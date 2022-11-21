//
//  SecondTextView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SecondTextView: UITextView {
    
    
    var scrollDelegate: SecondTextViewScrollDelegate?
    
    private let scTextStorage = SCTextStorage()
    
    private var colorViewModel: ColorVMType?
    
    private var disposeBag = DisposeBag()

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        let manager: TextWrapLayoutManager = TextWrapLayoutManager()
        
        scTextStorage.addLayoutManager(manager)
        
        manager.addTextContainer(textContainer!)
        
        super.init(frame: frame, textContainer: textContainer)
        
        settingConfiguration()

    }
    
    convenience init(frame: CGRect,
                     textContainer: NSTextContainer?,
                     _ delegate: SecondTextViewScrollDelegate,
                     _ viewModel: ColorVMType) {
        
        self.init(frame: frame, textContainer: textContainer)
        self.scrollDelegate = delegate
        self.colorViewModel = viewModel
        
        colorViewModel?
            .attributedStringObservable
            .subscribe(onNext: {[weak self] presentationType in
                
                guard let self = self else {return}
                
                self.setColorSelectedText(NSAttributedString.getAttributeColorKey(presentationType),
                                          self.getSeletedPragraphRange())
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func setColorSelectedText(_ key: [NSAttributedString.Key : Any],
                              _ paragraphRange: NSRange) {
        
        let attributes = self.textStorage.attributes(at: paragraphRange.location,
                                                        longestEffectiveRange: nil,
                                                        in: paragraphRange)
        
        if let backgroundColor = attributes[NSAttributedString.Key.backgroundColor] as? UIColor{
            undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
                targetSelf.setColorSelectedText([NSAttributedString.Key.backgroundColor : backgroundColor],
                                                paragraphRange)
            })
            
            // UndoButton redoButton isEnable
            self.colorViewModel?.onUndoActivity.onNext(())
        }else {
            print("fail")
        }
        
        self.scTextStorage.addAttributes(key, range: paragraphRange)
    }
    


    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    
    fileprivate func settingConfiguration() {
        self.allowsEditingTextAttributes = true
        
        self.layoutManager.delegate = self
        
        self.attributedText = testSetting()
        
        // 'no replacements Found popUp menu disable' when word select
        
        self.isScrollEnabled = true
        self.alwaysBounceVertical = false
        self.isUserInteractionEnabled = true
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        
        
        self.contentInset = UIEdgeInsets(top: 30, left: 12, bottom: 10, right: 12)
        
        self.autocorrectionType = .no
        
    }
    
  
    
    func insertAtTextViewCursor(attributedString: NSAttributedString) {
        // Exit if no selected text range
        guard let selectedRange = self.selectedTextRange else {
            return
        }
        
        // If here, insert <attributedString> at cursor
        let cursorIndex = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
        let mutableAttributedText = NSMutableAttributedString(attributedString: self.attributedText)
        mutableAttributedText.insert(attributedString, at: cursorIndex)
        self.attributedText = mutableAttributedText
    }
    
}


extension SecondTextView {
    
    private func getSeletedPragraphRange() -> NSRange {
        let seletedNSRange = self.selectedRange
        
        let nsString = self.text as NSString
        
        let paragraphRange = nsString.paragraphRange(for: seletedNSRange)
        
        return paragraphRange
    }
    
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var original = super.caretRect(for: position)
        
        guard let height = self.font?.lineHeight else { return original}
        
        original.size.height = height
        
        return original
    }
    
    private func scrollToCursorPositionIfBelowKeyboard() {
        let keyboardHeight: CGFloat = 295 + 44
        print("keyboardHeight", keyboardHeight)

        let caret = self.caretRect(for: self.selectedTextRange!.start)

        let keyboardTopBorder = self.bounds.size.height - keyboardHeight

        if caret.origin.y < keyboardTopBorder {

            self.scrollRectToVisible(caret, animated: true)

        }

    }
    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: false)
    }
    
    
}

extension SecondTextView: NSLayoutManagerDelegate{
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 8
    }
}
