//
//  Block.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/22.
//

import Foundation


/// Just a placeholder entity. User ReadBlock / WriteBlock structs.
public enum Block {
    public typealias Identifier = EntityIdentifier<Block, UUIDv4>
}

// MARK: - Codable

extension Block {
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case archived
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case hasChildren = "has_children"
        case color
        case object
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
    }
}
