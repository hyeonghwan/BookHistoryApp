//
//  BookPageMO+CoreDataProperties.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//
//

import Foundation
import CoreData


@objc(BookPageMO)
class BookPageMO: NSManagedObject {}

extension BookPageMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookPageMO> {
        return NSFetchRequest<BookPageMO>(entityName: "BookPage")
    }

    @NSManaged public var bookName: String?
    @NSManaged public var bookData: BookMO?

}

extension BookPageMO : Identifiable {

}
