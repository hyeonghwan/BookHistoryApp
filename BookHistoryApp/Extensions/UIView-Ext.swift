//
//  UIView-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/30.
//

import UIKit


extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
