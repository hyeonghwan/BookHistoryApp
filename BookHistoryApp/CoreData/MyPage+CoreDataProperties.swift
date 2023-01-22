//
//  MyPage+CoreDataProperties.swift
//  
//
//  Created by 박형환 on 2023/01/22.
//
//

import Foundation
import CoreData


@objc(MyPage)
public class MyPage: NSManagedObject {

}

extension MyPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyPage> {
        return NSFetchRequest<MyPage>(entityName: "MyPage")
    }

    @NSManaged public var properties: NSObject?
    @NSManaged public var archived: Bool
    @NSManaged public var parent: NSObject?
    @NSManaged public var cover: NSObject?
    @NSManaged public var icon: NSObject?
    @NSManaged public var lastEditedBy: NSObject?
    @NSManaged public var createdBy: NSObject?
    @NSManaged public var lastEditedTime: Date?
    @NSManaged public var createdTime: Date?
    @NSManaged public var id: NSObject?

}
