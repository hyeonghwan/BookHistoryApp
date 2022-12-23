//
//  BookMO+CoreDataProperties.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/24.
//
//

import Foundation
import CoreData

@objc(BookMO)
public class BookMO: NSManagedObject {

}

extension BookMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMO> {
        return NSFetchRequest<BookMO>(entityName: "BookData")
    }

    @NSManaged public var bookID: UUID?
    @NSManaged public var bookContent: NSAttributedString?
    @NSManaged public var bookTitle: String?
    @NSManaged public var bookPage: BookPageMO?

}

extension BookMO : Identifiable {

}
