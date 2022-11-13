//
//  ViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/08.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                          y: 0.0,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44.0))//1
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var container: UIView =    {
        let view = UIView()
        return view
    }()
    
    private lazy var textView: CustomTextView = {
        let textView = CustomTextView()
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        navigationSetting()
        self.view.backgroundColor = .systemCyan
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(textView)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(presentToSecondVC(_:)))
        
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        self.toolBar.setItems([flexible], animated: false)
        self.selectedBlockButton(title: "seleted", selector: #selector(selectedTapped(_:)))
        self.deleteColorBlockButton(title: "delteBlock", selector: #selector(deleteTapped(_:)))
        self.addColorBlockButton(title: "block", selector: #selector(addColorTapped(_:)))
        self.addDoneButton(title: "Done", selector: #selector(doneButtonTapped(_:)))
        
        
        self.textView.inputAccessoryView = toolBar
        
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        container.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalTo(self.view.snp.width).offset(-32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1000).priority(.low)
        }
        
        
        textView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.height.equalTo(1000).priority(.low)
        }
        
        
    }
    
 
    func navigationSetting(){
        self.title = "TextView"
    }
    
    @objc func presentToSecondVC(_ sender: Any){
        self.present(SecondViewController(), animated: true)
    }
    
    @objc func doneButtonTapped(_ sender: Any){
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    @objc func addColorTapped(_ sender: Any){
        self.textView.addColorForRange(theRange: self.textView.selectedRange)
    }
    
    
    @objc func deleteTapped(_ sender: Any){
        print(self.textView.selectedRange)
        self.textView.removeColorForRange(theRange: self.textView.selectedRange)
    }
    
    @objc func selectedTapped(_ sender: Any){
        
        
    }
    
}

extension ViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let allText: String = textView.text
        
        let composeText: NSString = allText as NSString
        
        let paragraphRange = composeText.paragraphRange(for: textView.selectedRange)
        
        print("paragraphRange \(paragraphRange)")
        
        let length = paragraphRange.length - (textView.selectedRange.location - paragraphRange.location)

        let newRange: NSRange = NSRange(location: textView.selectedRange.location, length: length)
        
        guard let textRange = textView.textRangeFromNSRange(range: newRange) else { return true }
        
        print("textRange: \(textRange)")
        print("textStart : \(textRange.start)")
        print("textEnd : \(textRange)")
        print("textFromRange: \(textView.text(in: textRange) ?? "nil")")
        
        
        if text == "\n",
           var insertString = (textView.text(in: textRange)),
           insertString.removeLastIfEnter(){
            
            let nlocation = textView.offset(from: textView.beginningOfDocument, to: textRange.start)
            let nlength = textView.offset(from: textRange.start, to: textRange.end)
            
            print("location, length : \(nlocation) \(nlength)")
            
            let nNewRange = NSRange(location: nlocation, length: nlength)
            
            _ = textView.textStorage.attributes(at: nNewRange.location,
                                                             longestEffectiveRange: nil,
                                                             in: nNewRange)

        }
        return true
    }
    
    

    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
    
        self.textView.setNeedsDisplay()
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldEndEditing")
        return true
    }
    
}

extension ViewController {
  
    func addDoneButton(title: String, selector: Selector) {
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
        
        self.toolBar.items?.append(barButton)
    }
    
    func addColorBlockButton(title: String, selector: Selector){
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
    
        self.toolBar.items?.append(barButton)
    }
    
    func deleteColorBlockButton(title: String, selector: Selector){
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
    
        self.toolBar.items?.append(barButton)
    }
    
    func selectedBlockButton(title: String, selector: Selector){
        
        let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)//3
    
        self.toolBar.items?.append(barButton)
    }
    
}


