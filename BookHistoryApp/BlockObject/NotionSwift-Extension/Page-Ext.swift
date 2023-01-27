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
    
    public func encode(with coder: NSCoder) {
        coder.encode(rawValue, forKey: "rawValue")
    }
    
    public init?(coder: NSCoder) {
        guard let raw = coder.decodeObject(forKey: "rawValue") as? String else {return nil}
        self.rawValue = raw
    }
    
    public var rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public override var description: String {
        "ID:\(rawValue)"
    }
  
}
