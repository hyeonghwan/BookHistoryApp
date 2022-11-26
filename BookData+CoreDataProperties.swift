//
//  BookData+CoreDataProperties.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//
//

import Foundation
import CoreData


extension BookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookData> {
        return NSFetchRequest<BookData>(entityName: "BookData")
    }

    @NSManaged public var bookTitle: String?
    @NSManaged public var bookContent: NSAttributedString?

}

extension BookData : Identifiable {

}
