//
//  SecondViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit
import SnapKit

class SecondViewController: UIViewController {

    let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                          y: 0.0,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44.0))//1
    
    
    lazy var textView: SecondTextView = {        
        let textView = SecondTextView(frame: .zero, textContainer: CustomTextContainer(size: .zero))
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(textView)
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        self.toolBar.setItems([flexible], animated: false)
        
        self.addColorBlockButton(title: "block", selector: #selector(addColorTapped(_:)))
        self.addDoneButton(title: "Done", selector: #selector(doneButtonTapped(_:)))
        self.textView.inputAccessoryView = toolBar
        
        textView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
    @objc func doneButtonTapped(_ sender: Any){
        self.view.endEditing(true)
    }
    
    @objc func addColorTapped(_ sender: Any){
        self.textView.textStorage.setAttributes([
            NSAttributedString.Key.backgroundColor : UIColor.systemPink,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor.systemPink
        ], range: self.textView.selectedRange)
    }
    
  
    
}
extension SecondViewController {
    
    func addDoneButton(title: String, selector: Selector) {
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
        
        self.toolBar.items?.append(barButton)
    }
    func addColorBlockButton(title: String, selector: Selector){
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
    
        self.toolBar.items?.append(barButton)
    }
    
}
