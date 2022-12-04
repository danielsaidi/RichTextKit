//
//  String+SubscriptTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class String_SubscriptTest: XCTestCase {
    
    let string = "foo bar baz"

    func testSharacterAtIndexIsValidWithinBounds() {
        XCTAssertEqual(string.character(at: 0), "f")
        XCTAssertEqual(string.character(at: 10), "z")
    }

    func testSharacterAtIndexIsNilOutsideBounds() {
        XCTAssertNil(string.character(at: -1))
        XCTAssertNil(string.character(at: 11))
    }

    func testSubscriptIsValidForDifferentOffsetAndRanges() {
        XCTAssertEqual(string[1], "o")
        XCTAssertEqual(string[1...4], "oo b")
        XCTAssertEqual(string[1..<4], "oo ")
    }
}
