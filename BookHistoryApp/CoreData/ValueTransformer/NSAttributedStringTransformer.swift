//
//  NSAttributedStringTransformer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//


import UIKit
import CoreData

@objc(NSAttributedStringTransformer)
public class NSAttributedStringTransformer: ValueTransformer {
    public override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let attributedString = value as? NSAttributedString else { return nil}
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: attributedString,
                                                        requiringSecureCoding: true)
            return data
        }catch{
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil}
        
        do{
            let attributedString = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data)
            
            return attributedString
        }catch{
            print("reverseTransformedValue nil")
            return nil
        }
    }

}


@objc(UIColorTransformer)
public class UIColorTransformer: ValueTransformer {
    public override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil}
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: color,
                                                        requiringSecureCoding: true)
            return data
        }catch{
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil}
        
        do{
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            
            return color
        }catch{
            print("reverseTransformedValue nil")
            return nil
        }
    }

}
