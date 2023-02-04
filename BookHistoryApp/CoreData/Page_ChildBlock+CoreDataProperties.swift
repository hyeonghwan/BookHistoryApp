//
//  Page_ChildBlock+CoreDataProperties.swift
//  
//
//  Created by 박형환 on 2023/01/31.
//
//

import Foundation
import CoreData

@objc(Page_ChildBlock)
public class Page_ChildBlock: NSManagedObject {

}
enum BlockKey: String{
    case ownObject
    case parentPage
}

extension Page_ChildBlock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page_ChildBlock> {
        return NSFetchRequest<Page_ChildBlock>(entityName: "Page_ChildBlock")
    }

    @NSManaged public var ownObject: BlockObject?
    @NSManaged public var block_ChildBlock: NSOrderedSet?
    @NSManaged public var parentPage: MyPage?

}

// MARK: Generated accessors for block_ChildBlock
extension Page_ChildBlock {

    @objc(addBlock_ChildBlockObject:)
    @NSManaged public func addToBlock_ChildBlock(_ value: Page_ChildBlock)

    @objc(removeBlock_ChildBlockObject:)
    @NSManaged public func removeFromBlock_ChildBlock(_ value: Page_ChildBlock)

    @objc(addBlock_ChildBlock:)
    @NSManaged public func addToBlock_ChildBlock(_ values: NSOrderedSet)

    @objc(removeBlock_ChildBlock:)
    @NSManaged public func removeFromBlock_ChildBlock(_ values: NSOrderedSet)

}
