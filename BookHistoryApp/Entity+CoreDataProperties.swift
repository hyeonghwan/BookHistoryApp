//
//  Entity+CoreDataProperties.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/24.
//
//

import Foundation
import CoreData

extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var bookTitle: String?
    @NSManaged public var bookContent: String?

}

extension Entity : Identifiable {

}
