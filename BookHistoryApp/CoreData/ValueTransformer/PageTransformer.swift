//
//  PageTransformer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/22.
//


import UIKit
import CoreData
import NotionSwift

@objc(IdentifierTransformer)
class IdentifierTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let identifier = value as? EntityIdentifier<Page, UUIDv4> else { return nil }
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        let data = try? jsonEncoder.encode(identifier)
        
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
      
        return try? JSONDecoder().decode(EntityIdentifier<Page, UUIDv4>.self, from: data)
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





