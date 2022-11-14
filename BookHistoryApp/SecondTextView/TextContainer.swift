//
//  TextContainer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/14.
//

import UIKit

class CustomTextContainer: NSTextContainer{
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        
        let originalFragmentRect = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
        
        
//        print("originalFragmentRect : \(originalFragmentRect)")
        
        
        return originalFragmentRect
    }
    
    
}
