//
//  Page-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/22.
//

import Foundation

public typealias NSObjCoding = NSObject & NSSecureCoding
public final class EntityIdentifier_C: NSObjCoding{
    
    public static var supportsSecureCoding: Bool {
        true
    }
    
    public var identity: String
    
    enum Key: String{
        case entityID
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(identity as NSString, forKey: Key.entityID.rawValue)
    }
    
    public init?(coder: NSCoder) {
        guard let raw = coder.decodeObject(forKey: Key.entityID.rawValue) as? NSString else {return nil}
        self.identity = raw as String
    }
    
    

    public init(_ identity: String) {
        self.identity = identity
    }

    public override var description: String {
        "ID:\(identity)"
    }
}
extension EntityIdentifier_C: Codable{}
