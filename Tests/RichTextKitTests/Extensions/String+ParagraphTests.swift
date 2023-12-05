//
//  String+ParagraphTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

final class String_ParagraphTests: XCTestCase {

    private let none = "foo bar baz"
    private let single = "foo\nbar baz"
    private let multi = "foo\nbar\rbaz"

    private func currentResult(for string: String, from location: UInt) -> UInt {
        string.findIndexOfCurrentParagraph(from: location)
    }

    private func nextResult(for string: String, from location: UInt) -> UInt {
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
        XCTAssertEqual(nextResult(for: "", from: 0), 0)
        XCTAssertEqual(nextResult(for: "", from: 20), 0)
    }

    func testIndexOfNextParagraphIsCorrectForStringWithNoNextParagraph() {
        XCTAssertEqual(nextResult(for: none, from: 0), 0)
        XCTAssertEqual(nextResult(for: none, from: 10), 0)
        XCTAssertEqual(nextResult(for: none, from: 20), 0)
    }

    func testIndexOfNextParagraphIsCorrectForStringWithSingleNextParagraph() {
        XCTAssertEqual(nextResult(for: single, from: 0), 4)
        XCTAssertEqual(nextResult(for: single, from: 5), 4)
        XCTAssertEqual(nextResult(for: single, from: 10), 4)
    }

    func testIndexOfNextParagraphIsCorrectForStringWithMultipleNextParagraphs() {
        XCTAssertEqual(nextResult(for: multi, from: 0), 4)
        XCTAssertEqual(nextResult(for: multi, from: 5), 8)
        XCTAssertEqual(nextResult(for: multi, from: 10), 8)
    }
}
