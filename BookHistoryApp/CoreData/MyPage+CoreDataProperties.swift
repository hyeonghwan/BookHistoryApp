//
//  MyPage+CoreDataProperties.swift
//  
//
//  Created by 박형환 on 2023/01/31.
//
//

import Foundation
import CoreData

@objc(MyPage)
public class MyPage: NSManagedObject {

}
enum PageKey: String{
    case id
    case archived
    case createdBy
    case lastEditedBy
    case createdTime
    case lastEditedTime
    case icon
}


extension MyPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPage> {
        return NSFetchRequest<MyPage>(entityName: "MyPage")
    }

    @NSManaged public var archived: Bool
    @NSManaged public var cover: String?
    @NSManaged public var createdBy: String?
    @NSManaged public var createdTime: Date?
    @NSManaged public var icon: String?
    @NSManaged public var id: EntityIdentifier_C?
    @NSManaged public var lastEditedBy: String?
    @NSManaged public var lastEditedTime: Date?
    @NSManaged public var childBlock: NSOrderedSet?

}

// MARK: Generated accessors for childBlock
extension MyPage {

    @objc(addChildBlockObject:)
    @NSManaged public func addToChildBlock(_ value: Page_ChildBlock)

    @objc(removeChildBlockObject:)
    @NSManaged public func removeFromChildBlock(_ value: Page_ChildBlock)

    @objc(addChildBlock:)
    @NSManaged public func addToChildBlock(_ values: NSOrderedSet)

    @objc(removeChildBlock:)
    @NSManaged public func removeFromChildBlock(_ values: NSOrderedSet)

}
