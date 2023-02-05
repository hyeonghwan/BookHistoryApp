//
//  PageModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/05.
//

import Foundation


struct PageModel{
    let pageID: String
    let title: String
}

extension PageModel: Equatable{
    static func == (lhs: PageModel, rhs: PageModel) -> Bool{
        return lhs.pageID == rhs.pageID
    }
}
