//
//  SecondViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/13.
//

import UIKit
import SnapKit

class SecondViewController: UIViewController {

    
    lazy var textView: UITextView = {
        let textView = UITextView()
        
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(textView)
        
        textView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        textView.attributedText = testSetting()
        
    }
    
    func testSetting() -> NSAttributedString{
        let richText = NSMutableAttributedString()

        let chunk0 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n\n",
                                        attributes: [
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        richText.append(chunk0)

        
        
        let interlineStyle = NSMutableParagraphStyle()
        
        interlineStyle.maximumLineHeight = 8
        
        let interlineAttributedString = NSMutableAttributedString(string: "\n",
                                                                  attributes: [
                                                                    NSAttributedString.Key.foregroundColor : UIColor.red,
                                                                    NSAttributedString.Key.paragraphStyle: interlineStyle
                                                                  ])
        
        let chunk1 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n",
                                        attributes: [
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        
        richText.append(chunk1)
        
        richText.append(interlineAttributedString)
        
        
        let chunk2 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n",
                                        attributes: [
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        richText.append(chunk2)
        
        return richText
    }


}
