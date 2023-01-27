//
//  Page_core.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/25.
//

import Foundation


public final class Page_C: NSObject,NSSecureCoding {
    
    
    public typealias UUID_C = String
    public typealias Identifier = EntityIdentifier_C
    
    public static var supportsSecureCoding: Bool = true
    
    
    typealias PropertyName = String
    let id: Identifier
    var createdTime: Date
    var lastEditedTime: Date
//    let createdBy: PartialUser_C
//    var lastEditedBy: PartialUser_C
//    var icon: IconFile_C?
//    var cover: CoverFile_C?
//    var parent: PageParentType_C
    var archived: Bool
//    var properties: [PropertyName : PageProperty_C]
    
    
    enum Key: String {
        case id = "title"
        case createdTime = "detail"
        case lastEditedTime = "date"
        case archived = "archived"
    }

    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Key.id.rawValue)
        coder.encode(createdTime, forKey: Key.createdTime.rawValue)
        coder.encode(lastEditedTime , forKey: Key.lastEditedTime.rawValue)
        coder.encode(archived, forKey: Key.archived.rawValue)
    }
    
    public convenience init?(coder: NSCoder) {
        guard let id_c = coder.decodeObject(forKey: Key.id.rawValue) as? Identifier,
              let createdTime_c = coder.decodeObject(forKey: Key.createdTime.rawValue) as? Date,
              let lastEditedTime_c = coder.decodeObject(forKey: Key.lastEditedTime.rawValue) as? Date,
              let archived_c = coder.decodeObject(forKey: Key.archived.rawValue) as? Bool else {return nil}
        
        self.init(id: id_c,
                  createdTime: createdTime_c,
                  lastEditedTime: lastEditedTime_c,
                  archived: archived_c)
    }
    
    
    public init(id: Identifier, createdTime: Date, lastEditedTime: Date, archived: Bool) {
        self.id = id
        self.createdTime = createdTime
        self.lastEditedTime = lastEditedTime
        self.archived = archived
    }
    
    
}
