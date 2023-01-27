//
//  PageTransformer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/22.
//


import UIKit
import CoreData
import NotionSwift


@objc(BlockTypeTransformer)
class BlockTypeTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let blockType = value as? BlockType_C else { return nil }
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: blockType,
                                                        requiringSecureCoding: true)
            return data
        }catch{
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil}
        do{
            let blockType = try NSKeyedUnarchiver.unarchivedObject(ofClass: BlockType_C.self, from: data)
            return blockType
        }catch{
            print("id blockType")
            return nil
        }
    }
}

@objc(IdentifierTransformer)
class IdentifierTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let identifier = value as? EntityIdentifier_C else { return nil }
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: identifier,
                                                        requiringSecureCoding: true)
            return data
        }catch{
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil}
        do{
            let id = try NSKeyedUnarchiver.unarchivedObject(ofClass: EntityIdentifier_C.self, from: data)
            return id
        }catch{
            print("id nil")
            return nil
        }
    }
}

@objc(PartialUserTransformer)
class PartialUserTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let partialUser = value as? PartialUser else { return nil }
        let jsonEncoder = JSONEncoder()
        
        let data = try? jsonEncoder.encode(partialUser)
        
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
      
        return try? JSONDecoder().decode(PartialUser.self, from: data)
    }
}

@objc(IconFileTransformer)
class IconFileTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let iconFile = value as? IconFile else { return nil }
        let jsonEncoder = JSONEncoder()
        
        let data = try? jsonEncoder.encode(iconFile)
        
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
      
        return try? JSONDecoder().decode(IconFile.self, from: data)
    }
}


@objc(CoverFileTransformer)
class CoverFileTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let coverFile = value as? CoverFile else { return nil }
        let jsonEncoder = JSONEncoder()
        
        let data = try? jsonEncoder.encode(coverFile)
        
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
      
        return try? JSONDecoder().decode(CoverFile.self, from: data)
    }
}

@objc(PageParentTypeTransformer)
class PageParentTypeTransformer: ValueTransformer{
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let parent = value as? PageParentType else { return nil }
        let jsonEncoder = JSONEncoder()
        
        let data = try? jsonEncoder.encode(parent)
        
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
      
        return try? JSONDecoder().decode(PageParentType.self, from: data)
    }
}

@objc(PagePropertiedTransformer)
class PagePropertiedTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let properties = value as? [String: WritePageProperty] else { return nil }
        let jsonEncoder = JSONEncoder()
        
        let data = try? jsonEncoder.encode(properties)
        
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
      
        return try? JSONDecoder().decode([String: PageProperty].self, from: data)
    }
}





