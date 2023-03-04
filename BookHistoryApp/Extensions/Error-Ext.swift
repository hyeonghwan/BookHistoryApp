//
//  Error-Ext.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/06.
//

import Foundation


enum CoreDataError: Error{
    case fetchContainerError
    case entityNameError
    case saveContextError
    case objectCastingError
    case fetchRequestError
    case unknown(String)
}

enum BlockError: Error{
    case blockValueNilError
    case blockObjectNilError
}
