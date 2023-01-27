//
//  BlockObject.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import Foundation


protocol BlockObjectType: NSObjCoding{
    var object: BlockTypeWrapping? { get }
//    var object: BlockElement? { get }
}



protocol BlockElement{
    func editRawText(_ text: String)
    var richText: RichTextElement? {get set}
    var children: [BlockObject]? { get set }
    var decription: String { get }
}
//@NSManaged public var id: EntityIdentifier_C
//@NSManaged public var type: BlockType_C? // enum // not
//@NSManaged public var archived: Bool // yet
//@NSManaged public var createdTime: Date?
//@NSManaged public var lastEditedTime: Date?
//@NSManaged public var hasChildren: Bool
//@NSManaged public var color: UIColor?
//@NSManaged public var object: BlockObject? // blockObject
//@NSManaged public var createdBy: String?
//@NSManaged public var lastEditedBy: String?
//@NSManaged public var parentPage: MyPage
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



public final class BlockObject: NSObject, BlockObjectType{
    var blockInfo: BlockInfo?
    var object: BlockTypeWrapping?
    var blockType: CustomBlockType?
    
    public static var supportsSecureCoding: Bool {
        true
    }
    enum Key: String{
        case object
        case blockInfo
        
    }
    
    public func encode(with coder: NSCoder) {
        if let blockType = blockType {
            coder.encode(blockType, forKey: Key.object.rawValue)
        }
        if let blockInfo = blockInfo{
            coder.encode(blockInfo, forKey: Key.blockInfo.rawValue)
        }
        
    }
    
    public convenience init?(coder: NSCoder) {
        guard let object = coder.decodeObject(forKey: Key.object.rawValue) as? BlockTypeWrapping else {return nil}
        let blockInfo = coder.decodeObject(forKey: Key.blockInfo.rawValue) as? BlockInfo
        let type: CustomBlockType = object.e

        self.init(blockInfo: blockInfo, object: object, blockType:type )
    }

    
    init(blockInfo: BlockInfo?,
        object: BlockTypeWrapping?,
         blockType: CustomBlockType?) {
        self.blockInfo = blockInfo
        self.object = object
        self.blockType = blockType
    }
}


// blockObject -> ToggleBlock -> richTextElement,child(BlockElement) -> RawTextElement