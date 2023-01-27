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
    public typealias Identifier = EntityIdentifier_C


    @NSManaged public var archived: Bool
    @NSManaged public var parent: PageParentType_C
    @NSManaged public var cover: String?
    @NSManaged public var icon: String?
    @NSManaged public var lastEditedBy: String?
    @NSManaged public var createdBy: String?
    @NSManaged public var lastEditedTime: Date?
    @NSManaged public var createdTime: Date?
    @NSManaged public var id: EntityIdentifier_C
    @NSManaged public var childBlocks: [Page_ChildBlock]?
}
extension MyPage : Identifiable{ }
