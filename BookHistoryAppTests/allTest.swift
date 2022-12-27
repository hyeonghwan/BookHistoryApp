//
//  File.swift
//  BookHistoryAppTests
//
//  Created by 박형환 on 2022/12/26.
//
import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParagraphTextStorageTests.allTests),
    ]
}
#endif
