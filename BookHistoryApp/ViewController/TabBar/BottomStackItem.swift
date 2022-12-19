//
//  BottomStackItem.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/19.
//

import Foundation


class BottomStackItem {
    
    var title: String
    var image: String
    var isSelected: Bool
    
    init(title: String,
         image: String,
         isSelected: Bool = false) {
        self.title = title
        self.image = image
        self.isSelected = isSelected
    }
    
}
