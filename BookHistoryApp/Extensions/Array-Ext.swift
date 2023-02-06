//
//  Array-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/06.
//

import Foundation


extension Dictionary where Key == NSAttributedString.Key {
    
    func getBlockBaseType() -> CustomBlockType.Base{
        if let value = self[.blockType] as? CustomBlockType.Base{
            return value
        }else{
            return CustomBlockType.Base.none
        }
    }
    
}
