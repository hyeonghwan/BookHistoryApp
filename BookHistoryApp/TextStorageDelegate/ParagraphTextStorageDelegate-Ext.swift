//
//  ParagraphTextStorageDelegate-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/24.
//

import ParagraphTextKit
import Foundation

extension ParagraphTextStorage{
    
    private func newLine_insert(_ index: Int){
        self.beginEditing()
    
        self.insert(NSAttributedString.paragraphNewLine, at: index)
        
        self.endEditing()
    }
   
    
    public func insertedPlaceHolder(with attString: NSAttributedString, insert range: NSRange, last line: Bool){
        let insertedRange = range
        
        let attString = attString
        let mutable = NSMutableAttributedString()
        if line{
            mutable.append(NSAttributedString.paragraphNewLine)
            mutable.append(attString)
            
            self.beginEditing()
            self.insert(mutable, at: insertedRange.max)
            self.endEditing()
            
        }else{
            
            self.newLine_insert(insertedRange.max)
            
            mutable.append(attString)
            mutable.append(NSMutableAttributedString.paragraphNewLine)
            
            self.beginEditing()
            self.replaceCharacters(in: NSRange(location: insertedRange.max, length: 1), with: mutable)
            self.endEditing()
        }
        
    }
}
