//
//  BlockObject.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import Foundation
import UIKit





protocol BlockElement{
    func editRawText(_ text: String)
    var richText: RichTextElement? {get set}
    var children: [BlockObject]? { get set }
    var decription: String { get }
}


enum BlockObjectKeys: String{
    
    case blockInfos
    
    case id
    case type
    case archived
    case createdTime
    case lastEditedTime
    case hasChildren
    case color
    case object
    case createdBy
    case lastEditedBy
    case parentPage
}


struct BlockInfo {
    var id: EntityIdentifier_C? // class type
    var type: CustomBlockType.Base? // class type
    var archived: Bool?
    var createdTime: Date?
    var lastEditedTime: Date?
    var hasChildren: Bool?
    var color: String?
    var createdBy: String?
    var lastEditedBy: String?
}
extension BlockInfo: Equatable,Hashable{
    static func == (lhs: BlockInfo, rhs: BlockInfo) -> Bool{
        return lhs.id == rhs.id
    }
}

extension BlockInfo: Codable{
    enum CodingKeys: String, CodingKey {
          case id
          case type
          case archived
          case createdTime
          case lastEditedTime
          case hasChildren
          case color
          case createdBy
          case lastEditedBy
      }
      public func encode(to encoder: Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(id, forKey: .id)
          try container.encode(type?.rawValue, forKey: .type)
          try container.encode(archived, forKey: .archived)
          try container.encode(createdTime, forKey: .createdTime)
          try container.encode(lastEditedTime, forKey: .lastEditedTime)
          try container.encode(hasChildren, forKey: .hasChildren)
          try container.encode(color, forKey: .color)
          try container.encode(createdBy, forKey: .createdBy)
          try container.encode(lastEditedBy, forKey: .lastEditedBy)
      }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(EntityIdentifier_C.self, forKey: .id)
        let typeValue = try container.decode(String.self, forKey: .type)
        type = CustomBlockType.Base(rawValue: typeValue) ?? Optional.none
        archived = try container.decode(Bool.self, forKey: .archived)
        createdTime = try container.decode(Date.self, forKey: .createdTime)
        lastEditedTime = try container.decode(Date.self, forKey: .lastEditedTime)
        hasChildren = try container.decode(Bool.self, forKey: .hasChildren)
        color = try container.decode(String.self, forKey: .color)
        createdBy = try container.decode(String.self, forKey: .createdBy)
        lastEditedBy = try container.decode(String.self, forKey: .lastEditedBy)
    }
    
}

protocol BlockObjectType: NSObjCoding{
    var object: BlockTypeWrapping? { get }
}

class Node {
    let node: [Node]
    
    init(node: [Node]) {
        self.node = node
    }
}

public final class BlockObject: NSObjCoding{
    var blockInfo: BlockInfo?
    lazy var object: BlockTypeWrapping? = nil
    var blockType: CustomBlockType?
    
    private var _threeAttributes: [[[NSAttributedString.Key : Any]]] = []
    
    public override var description: String {
        return "description,: \(self.blockType?.base ?? CustomBlockType.Base.none)  description,object: \(String(describing: self.object?.description)) \n-------------\n"
    }
    
    public static var supportsSecureCoding: Bool {
        true
    }
    enum Key: String{
        case object
        case blockInfo
    }
    
    public func encode(with coder: NSCoder) {
        if let object = object {
            print("encode block object : \(object)")
            print("encode block custom Type : \(object.e)")
            coder.encode(object, forKey: Key.object.rawValue)
            print("blockObject encode end")
        }
        print("asdfsfdasfasdf")
        
        if let blockInfo = blockInfo{
            print("encode block info")
            let encoder = JSONEncoder()
            do{
                let encodedData = try encoder.encode(blockInfo)
                
                let nsData = NSData(data: encodedData)
                
                coder.encode(nsData, forKey: Key.blockInfo.rawValue)
            }catch{
                print(error)
            }
//            coder.encode(blockInfo, forKey: Key.blockInfo.rawValue)
        }
        
        
    }
    
    public convenience init?(coder: NSCoder) {

        do {
            let object = coder.decodeObject(of: BlockTypeWrapping.self, forKey: Key.object.rawValue)
            
            guard let nsData = coder.decodeObject(forKey: Key.blockInfo.rawValue) as? NSData else {return nil}
            
            let decoder = JSONDecoder()
            
            let blockInfo = try decoder.decode(BlockInfo.self, from: nsData as Data)
            
            let type: CustomBlockType? = object?.e

            self.init(blockInfo: blockInfo, object: object, blockType:type )
        }catch{
            
            return nil
        }
    }

    
    init(blockInfo: BlockInfo?,
        object: BlockTypeWrapping?,
         blockType: CustomBlockType?) {
        super.init()
        self.blockInfo = blockInfo
        self.object = object
        self.blockType = blockType
    }
}


extension BlockObject {
    func getBlockValueType() -> BlockValueType? {
        do{
            let value = try BlockTypeBuilder()
                .getBlockValueType(block: self.object?.e ?? .none)
                .buildObject()
            return value
        }catch{
            print("error block error : \(error)")
        }
        return nil
    }
}
extension BlockObject{
    
    var threeAttributes: [[[NSAttributedString.Key : Any]]] {
        get {
            return _threeAttributes
        }
        set {
            _threeAttributes = newValue
        }
    }
   
    func getAllObejctAttributes() -> [[[NSAttributedString.Key : Any]]]{
        let value = self.getObjectAttributes()
        if value.count == 0{
            return threeAttributes
        }
        return [value]
    }
    
    func getObjectAttributes() -> [[NSAttributedString.Key : Any]] {
        guard let wrappingObject = self.object else { return []}
        
        let builder = BlockTypeBuilder()
        var type = CustomBlockType.Base.paragraph
        
        if let getType = self.object?.e.base{
           type = getType
        }
        do {
            guard let object
                    =
                    try builder
                .getBlockValueType(block: wrappingObject.e)
                .buildObject()
            else {return []}
            
            if object.children == nil{
                let attributes
                =
                try builder
                    .getBlockBaseType(type: type)
                    .getDefaultAttributes()
                    .buildAttributes()
                    .build()
                return attributes
            }
            
            if object.children != nil{
                threeAttributes = object.children!.map{ childBlockObject in
                    childBlockObject.getObjectAttributes()
                }
            }
            return []
        }catch{
            fatalError("fattal error occur")
        }
    }
    
    
    func editAttributes(_ attributes: [[NSAttributedString.Key : Any]]){
        guard let wrappingObject = self.object else { return }
        
        wrappingObject.e.editAttributes(attributes)
    }
    
    func editTextElement(_ str: [String],_ attributes: [[NSAttributedString.Key : Any]]){
        guard let wrappingObject = self.object else { return }
        wrappingObject.e.editElement(str, attributes)
    }
}


// blockObject -> ToggleBlock -> richTextElement,child(BlockElement) -> RawTextElement
