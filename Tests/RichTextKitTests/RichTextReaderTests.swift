//
//  RichTextReaderTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-06.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class RichTextReaderTests: XCTestCase {
    
    let string = NSAttributedString(string: "foo bar baz")


    func testRichTextAtRangeIsValidForEmptyRangeInEmptyString() {
        let range = NSRange(location: 0, length: 0)
        let string = NSAttributedString(string: "")
        let result = string.richText(at: range).string
        XCTAssertEqual(result, "")
    }

    func testRichTextAtRangeIsValidForValidRange() {
        let range = NSRange(location: 4, length: 3)
        let result = string.richText(at: range).string
        XCTAssertEqual(result, "bar")
    }

    func testRichTextAtRangeIsValidForInvalidPositionRange() {
        let range = NSRange(location: -1, length: 3)
        let result = string.richText(at: range).string
        XCTAssertEqual(result, "foo")
    }

    func testRichTextAtRangeIsValidForInvalidLengthRange() {
        let range = NSRange(location: 8, length: 4)
        let result = string.richText(at: range).string
        XCTAssertEqual(result, "baz")
    }


    func testSafeRangeIsValidForEmptyRangeInEmptyString() {
        let range = NSRange(location: 0, length: 0)
        let string = NSAttributedString(string: "")
        let result = string.safeRange(for: range)
        XCTAssertEqual(result.location, 0)
        XCTAssertEqual(result.length, 0)
    }

    func testSafeRangeIsValidForValidRange() {
        let range = NSRange(location: 4, length: 3)
        let result = string.safeRange(for: range)
        XCTAssertEqual(result.location, 4)
        XCTAssertEqual(result.length, 3)
    }

    func testSafeRangeIsValidForInvalidPositionRange() {
        let range = NSRange(location: -1, length: 3)
        let result = string.safeRange(for: range)
        XCTAssertEqual(result.location, 0)
        XCTAssertEqual(result.length, 3)
    }

    func testSafeRangeIsValidForInvalidLengthRange() {
        let range = NSRange(location: 8, length: 4)
        let result = string.safeRange(for: range)
        XCTAssertEqual(result.location, 8)
        XCTAssertEqual(result.length, 3)
    }
    
    func testSafeRangeLimitsLocationToUpperLimit() {
        let range = NSRange(location: 12, length: 4)
        let result = string.safeRange(for: range)
        XCTAssertEqual(result.location, 11)
        XCTAssertEqual(result.length, 0)
    }
    
    func testSafeRangeLimitsLocationToNextToUpperLimitForAttributes() {
        let range = NSRange(location: 12, length: 4)
        let result = string.safeRange(for: range, isAttributeOperation: true)
        XCTAssertEqual(result.location, 10)
        XCTAssertEqual(result.length, 0)
    }
}
