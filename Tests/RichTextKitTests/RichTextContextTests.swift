//
//  RichTextContextTests.swift
//  RichTextKit

//  Created by Daniel Saidi on 2022-12-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class RichTextContextTests: XCTestCase {
    
    func testInitializerSetsFontSize() {
        let context = RichTextContext(standardFontSize: 10)
        XCTAssertEqual(context.fontSize, 10)
    }

    func testInitializerSetsDefaultValues() {
        let context = RichTextContext()
        XCTAssertEqual(context.fontName, "")
        XCTAssertEqual(context.fontSize, 16)
        XCTAssertFalse(context.isBold)
        XCTAssertFalse(context.isItalic)
        XCTAssertFalse(context.isUnderlined)
        XCTAssertFalse(context.isEditingText)
        XCTAssertNil(context.highlightedRange)
        XCTAssertEqual(context.selectedRange.location, 0)
        XCTAssertEqual(context.selectedRange.length, 0)
        XCTAssertEqual(context.alignment, .left)
    }

    func testHighlightingRangeSetsHighlightedRange() {
        let context = RichTextContext()
        let range = NSRange(location: 1, length: 2)
        context.highlightRange(range)
        XCTAssertEqual(context.highlightedRange, range)
    }

    func testResetingHighlightResetsHighlightedRange() {
        let context = RichTextContext()
        let range = NSRange(location: 1, length: 2)
        context.highlightRange(range)
        context.resetHighlightedRange()
        XCTAssertNil(context.highlightedRange)
    }

    func testStopEditingTextSetsPropertyToFalse() {
        let context = RichTextContext()
        context.isEditingText = true
        context.stopEditingText()
        XCTAssertFalse(context.isEditingText)
    }

    func testTriggeringFontSizeTriggersSetsOropertiesToTrue() {
        let context = RichTextContext()
        let fontSize = context.fontSize
        context.decrementFontSize()
        XCTAssertNotEqual(context.fontSize, fontSize)
        context.incrementFontSize(points: 3)
        XCTAssertNotEqual(context.fontSize, fontSize)
        context.decrementFontSize(points: 2)
        XCTAssertEqual(context.fontSize, fontSize)
    }
}
