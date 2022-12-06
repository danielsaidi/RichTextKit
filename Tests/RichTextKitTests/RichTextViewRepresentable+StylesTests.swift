//
//  RichTextViewRepresentable+StylesTest.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS) || os(tvOS)
import RichTextKit
import XCTest

class RichTextViewRepresentable_StylesTests: XCTestCase {

    var textView: RichTextViewRepresentable!

    let noRange = NSRange(location: 0, length: 0)
    let selectedRange = NSRange(location: 4, length: 3)

    override func setUp() {
        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz"),
            format: .rtf
        )
    }


    func testIsCurrentTextBoldWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextStyle(.bold, to: true)
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.bold))
        textView.setSelectedRange(noRange)
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.bold))
    }

    func testIsCurrentTextBoldWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentRichTextStyle(.bold, to: true)
        #if os(iOS) || os(tvOS)
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.bold))
        #endif
        textView.setSelectedRange(selectedRange)
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.bold))
    }


    func testIsCurrentTextItalicWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextStyle(.italic, to: true)
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.italic))
        textView.setSelectedRange(noRange)
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.italic))
    }

    func testIsCurrentTextItalicWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentRichTextStyle(.italic, to: true)
        #if os(iOS) || os(tvOS)
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.italic))
        #endif
        textView.setSelectedRange(selectedRange)
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.italic))
    }


    func testIsCurrentTextUnderlinedWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextStyle(.underlined, to: true)
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.underlined))
        textView.setSelectedRange(noRange)
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.underlined))
    }

    func testIsCurrentTextUnderlinedWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentRichTextStyle(.underlined, to: true)
        #if os(iOS) || os(tvOS)
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.underlined))
        #endif
        textView.setSelectedRange(selectedRange)
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.underlined))
    }
}
#endif
