//
//  BlockObject.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/15.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class Welcome: Codable {
    let object, id: String
    let parent: Parent
    let createdTime, lastEditedTime: String
    let createdBy, lastEditedBy: TedBy
    let hasChildren, archived: Bool
    let type: String
    let heading2: Heading2

    enum CodingKeys: String, CodingKey {
        case object, id, parent
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
        case hasChildren = "has_children"
        case archived, type
        case heading2 = "heading_2"
    }

    init(object: String, id: String, parent: Parent, createdTime: String, lastEditedTime: String, createdBy: TedBy, lastEditedBy: TedBy, hasChildren: Bool, archived: Bool, type: String, heading2: Heading2) {
        self.object = object
        self.id = id
        self.parent = parent
        self.createdTime = createdTime
        self.lastEditedTime = lastEditedTime
        self.createdBy = createdBy
        self.lastEditedBy = lastEditedBy
        self.hasChildren = hasChildren
        self.archived = archived
        self.type = type
        self.heading2 = heading2
    }
}

// MARK: - TedBy
class TedBy: Codable {
    let object, id: String

    init(object: String, id: String) {
        self.object = object
        self.id = id
    }
}

// MARK: - Heading2
class Heading2: Codable {
    let richText: [RichText]
    let color: String
    let isToggleable: Bool

    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
        case color
        case isToggleable = "is_toggleable"
    }

    init(richText: [RichText], color: String, isToggleable: Bool) {
        self.richText = richText
        self.color = color
        self.isToggleable = isToggleable
    }
}

// MARK: - RichText
class RichText: Codable {
    let type: String
    let text: Text
    let annotations: Annotations
    let plainText: String
    let href: JSONNull?

    enum CodingKeys: String, CodingKey {
        case type, text, annotations
        case plainText = "plain_text"
        case href
    }

    init(type: String, text: Text, annotations: Annotations, plainText: String, href: JSONNull?) {
        self.type = type
        self.text = text
        self.annotations = annotations
        self.plainText = plainText
        self.href = href
    }
}

// MARK: - Annotations
class Annotations: Codable {
    let bold, italic, strikethrough, underline: Bool
    let code: Bool
    let color: String

    init(bold: Bool, italic: Bool, strikethrough: Bool, underline: Bool, code: Bool, color: String) {
        self.bold = bold
        self.italic = italic
        self.strikethrough = strikethrough
        self.underline = underline
        self.code = code
        self.color = color
    }
}

// MARK: - Text
class Text: Codable {
    let content: String
    let link: JSONNull?

    init(content: String, link: JSONNull?) {
        self.content = content
        self.link = link
    }
}

// MARK: - Parent
class Parent: Codable {
    let type, pageID: String

    enum CodingKeys: String, CodingKey {
        case type
        case pageID = "page_id"
    }

    init(type: String, pageID: String) {
        self.type = type
        self.pageID = pageID
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
