//
//  SCTextView-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit
import SubviewAttachingTextView

extension UITextView{
    
    func titlePlaceHolderSetting() -> NSAttributedString{
        let titleText = NSMutableAttributedString()
        
        let att = NSAttributedString(string: "제목 없음",
                                     attributes: [.font : UIFont.boldSystemFont(ofSize: 20),
                                                  .foregroundColor : UIColor.lightGray])
        titleText.append(att)
        
        return titleText
        
    }
    
    static func testSetting2() -> NSAttributedString{
        let chunk2 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n\n\n\n\n\n\n\n\n\n\n\n\n\n",
                                        attributes: [
                                            NSAttributedString.Key.backgroundColor : UIColor.red,
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        return chunk2
    }
    static func testSetting3() -> NSAttributedString{
    
        let interlineAttributedString = NSMutableAttributedString(string: "\n",
                                                                  attributes: [
                                                                    NSAttributedString.Key.backgroundColor : UIColor.red,
                                                                    NSAttributedString.Key.foregroundColor : UIColor.red,
                                                                  ])
        
        
        let chunk1 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n",
                                        attributes: [
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        
        
        return chunk1
    }
    static func testSetting() -> NSAttributedString{
        let chunk0 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n\n",
                                        attributes: [
                                            NSAttributedString.Key.baselineOffset : 10 ,
                                            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.double.rawValue,
                                            NSAttributedString.Key.underlineColor : UIColor(red: 51 / 255.0, green: 154 / 255.0, blue: 1.0, alpha: 1.0),
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        return chunk0
    }
}
