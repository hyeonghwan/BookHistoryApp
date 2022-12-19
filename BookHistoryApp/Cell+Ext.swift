//
//  Cell+Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/23.
//

import UIKit


protocol CellIdentifiable{
    static var identify: String { get }
}
extension CellIdentifiable{
    static var identify : String {
        return String(describing: Self.self)
    }
}

extension BookPagingTableViewCell: CellIdentifiable {}
