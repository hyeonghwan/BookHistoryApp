//
//  PageParentType_c.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/25.
//

import Foundation


public enum PageParentTypeEnum: String{
    case database
    case page
    case workspace
    case unknown
}

public final class PageParentType_C: NSObject,NSSecureCoding{
    public static var supportsSecureCoding: Bool {
        true
    }
    
    var type: String
    
    enum Key: String{
        case type = "type"
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(type, forKey: Key.type.rawValue)
    }
    
    public convenience init?(coder: NSCoder) {
        guard let type_d = coder.decodeObject(forKey: Key.type.rawValue) as? String else {return nil}
        
        guard let enumType = PageParentTypeEnum(rawValue: type_d) else {return nil}
        
        self.init(enumType)
        
    }
    
    public init(_ type: PageParentTypeEnum) {
        self.type = type.rawValue
    }
}
