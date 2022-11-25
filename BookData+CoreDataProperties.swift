//
//  BookData+CoreDataProperties.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/24.
//
//

import Foundation
import CoreData


extension BookMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMO> {
        return NSFetchRequest<BookMO>(entityName: "BookData")
    }

    
}

extension BookMO : Identifiable {

}
