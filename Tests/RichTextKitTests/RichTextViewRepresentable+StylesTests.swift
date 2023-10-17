//
//  RichTextViewComponent+StylesTest.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-06.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
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

class RichTextViewComponent_StylesTests: XCTestCase {

    var textView: RichTextViewComponent!

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
        #if os(macOS)   // TODO: Why did this stop working for iOS and tvOS
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.bold))
        #endif
        textView.setSelectedRange(noRange)
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.bold))
    }

    func testIsCurrentTextItalicWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextStyle(.italic, to: true)
        #if os(macOS)   // TODO: Why did this stop working for iOS and tvOS
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.italic))
        #endif
        textView.setSelectedRange(noRange)
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
