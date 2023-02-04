//
//  BlockObjectTranfomer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/28.
//

import Foundation


@objc(BlockObjectTransformer)
public class BlockObjectTransformer: ValueTransformer {
    public override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    public override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let blockObject = value as? BlockObject else { return nil}
        
        do{
            print("transformedValue : \(blockObject)")
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: blockObject,
                                                        requiringSecureCoding: true)
            print("transformedValue : \(data)")
            print("transformedValue BLockObject")
            return data
        }catch{
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        print("asfsdfa")
        guard let data = value as? Data else { return nil}
        print("data : \(data)")
        do{
            print("try blockObject")
            
            let blockObject = try NSKeyedUnarchiver.unarchivedObject(ofClass: BlockObject.self, from: data)
            
            return blockObject
        }catch{
            print("blockObject nil")
            return nil
        }
    }

}
