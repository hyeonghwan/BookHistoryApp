//
//  Page_ChildBlock+CoreDataProperties.swift
//  
//
//  Created by 박형환 on 2023/01/25.
//
//

import UIKit
import CoreData
import NotionSwift

public class Page_ChildBlock: NSManagedObject {}

extension Page_ChildBlock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page_ChildBlock> {
        return NSFetchRequest<Page_ChildBlock>(entityName: "Page_ChildBlock")
    }
    @NSManaged public var childrenBLocks: Page_ChildBlock?
    @NSManaged public var object: BlockObject? // blockObject
    @NSManaged public var parentPage: MyPage?
}

enum BlockKey: String{
    case childrenBLocks
    case object
    case parentPage
}
