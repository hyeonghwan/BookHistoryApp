//
//  TestViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/21.
//

import UIKit
import SnapKit
import OpenGraph


class TestViewController: UIViewController{
    
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.attributedText = text.titlePlaceHolderSetting()
        text.delegate = self
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textView)
        textView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.trailing.leading.equalToSuperview()
        }
        textView.text = "Placeholder"
    }

}

extension TestViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
}
