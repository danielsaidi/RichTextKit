//
//  String+ParagraphTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class String_ParagraphTests: XCTestCase {
    
    let none = "foo bar baz"
    let single = "foo\nbar baz"
    let multi = "foo\nbar\rbaz"

    func currentResult(for string: String, from location: UInt) -> UInt {
        string.findIndexOfCurrentParagraph(from: location)
    }

    func nextTesult(for string: String, from location: UInt) -> UInt {
        string.findIndexOfNextParagraph(from: location)
    }


    func testIndexOfCurrentParagraphIsCorrectForEmptyString() {
        XCTAssertEqual(currentResult(for: "", from: 0), 0)
        XCTAssertEqual(currentResult(for: "", from: 20), 0)
    }

    func testIndexOfCurrentParagraphIsCorrectForStringWithNoPreviousParagraph() {
        XCTAssertEqual(currentResult(for: none, from: 0), 0)
        XCTAssertEqual(currentResult(for: none, from: 10), 0)
        XCTAssertEqual(currentResult(for: none, from: 20), 0)
    }

    func testIndexOfCurrentParagraphIsCorrectForStringWithSinglePreviousParagraph() {
        XCTAssertEqual(currentResult(for: single, from: 0), 0)
        XCTAssertEqual(currentResult(for: single, from: 5), 4)
        XCTAssertEqual(currentResult(for: single, from: 10), 4)
    }

    func testIndexOfCurrentParagraphIsCorrectForStringWithManyPreviousParagraphs() {
        XCTAssertEqual(currentResult(for: multi, from: 0), 0)
        XCTAssertEqual(currentResult(for: multi, from: 5), 4)
        XCTAssertEqual(currentResult(for: multi, from: 10), 8)
    }


    func testIndexOfNextParagraphIsCorrectForEmptyString() {
        XCTAssertEqual(nextTesult(for: "", from: 0), 0)
        XCTAssertEqual(nextTesult(for: "", from: 20), 0)
    }

    func testIndexOfNextParagraphIsCorrectForStringWithNoNextParagraph() {
        XCTAssertEqual(nextTesult(for: none, from: 0), 0)
        XCTAssertEqual(nextTesult(for: none, from: 10), 0)
        XCTAssertEqual(nextTesult(for: none, from: 20), 0)
    }

    func testIndexOfNextParagraphIsCorrectForStringWithSingleNextParagraph() {
        XCTAssertEqual(nextTesult(for: single, from: 0), 4)
        XCTAssertEqual(nextTesult(for: single, from: 5), 4)
        XCTAssertEqual(nextTesult(for: single, from: 10), 4)
    }

    func testIndexOfNextParagraphIsCorrectForStringWithMultipleNextParagraphs() {
        XCTAssertEqual(nextTesult(for: multi, from: 0), 4)
        XCTAssertEqual(nextTesult(for: multi, from: 5), 8)
        XCTAssertEqual(nextTesult(for: multi, from: 10), 8)
    }
}
