//
//  NSRange-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/18.
//

import Foundation

extension NSRange{
    
    /// get replaceRange about toggle and TextHeadSymbol
    /// - Parameter content: content
    /// - Returns: replceRange
    ///  toggle,textHeadSymbol 은 첫번째 range 에 NSattachMent를 가지기 때문에 location을 1plus 하였다.
    ///  lenth 는 \n 은 바꾸지 않기에 - 2하여 view와 \n 을 제외한 text만 포함한다.
    func toggleReplaceRange(textView count: Int) -> NSRange{
        var replaceRange: NSRange = NSRange(location: self.location + 1, length: self.length - 2)
        
        if self.max == count{
            replaceRange = NSRange(location: self.location + 1, length: self.length - 1)
        }
        return replaceRange
    }
}
