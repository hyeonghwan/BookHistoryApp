//
//  SCTextView-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit

extension SecondTextView{
    
    
    func testSetting() -> NSAttributedString{
        
        let richText = NSMutableAttributedString()
        
        
        //하 시발 존나 허망하네
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 4
        
        para.lineBreakMode = .byWordWrapping
        
        let chunk0 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n\n",
                                        attributes: [
                                            
                                            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                                            NSAttributedString.Key.underlineColor : UIColor(red: 51 / 255.0, green: 154 / 255.0, blue: 1.0, alpha: 1.0),
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.paragraphStyle : para,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        
        richText.append(chunk0)
        
        

        
        let interlineStyle = NSMutableParagraphStyle()
        
        interlineStyle.maximumLineHeight = 8
        
        let interlineAttributedString = NSMutableAttributedString(string: "\n",
                                                                  attributes: [
                                                                    NSAttributedString.Key.backgroundColor : UIColor.red,
                                                                    NSAttributedString.Key.foregroundColor : UIColor.red,
                                                                    NSAttributedString.Key.paragraphStyle: interlineStyle
                                                                  ])
        
        
        let chunk1 = NSAttributedString(string: "Something like this where it breaks to its own line and creates a box that goes to the edge no matter how long the text is \n",
                                        attributes: [
                                            NSAttributedString.Key.foregroundColor : UIColor.label,
                                            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                        ])
        
        
//        richText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: NSRange)
        
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
