//
//  BookData+CoreDataClass.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/24.
//
//

import Foundation
import CoreData

@objc(BookMO)
public class BookMO: NSManagedObject {
    
    @NSManaged public var bookTitle: String?
    @NSManaged public var bookContent: String?

}
