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

#if macOS
import AppKit
#endif

#if iOS || macOS || os(tvOS)
import RichTextKit
import XCTest

final class RichTextViewComponent_StylesTests: XCTestCase {

    private var textView: RichTextViewComponent!

    private let noRange = NSRange(location: 0, length: 0)
    private let selectedRange = NSRange(location: 4, length: 3)

    override func setUp() {
        super.setUp()

        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz"),
            format: .rtf,
            linkColor: .cyan
        )
    }

    override func tearDown() {
        textView = nil

        super.tearDown()
    }

    func testIsCurrentTextBoldWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextStyleTypingAttributes(.bold, to: true)
        #if macOS   // TODO: Why did this stop working for iOS and tvOS
        XCTAssertTrue(textView.currentRichTextTypingAttributeStyles.hasStyle(.bold))
        #endif
        textView.setSelectedRange(noRange)
        XCTAssertFalse(textView.currentRichTextTypingAttributeStyles.hasStyle(.bold))
    }

    func testIsCurrentTextItalicWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextStyleTypingAttributes(.italic, to: true)
        #if macOS   // TODO: Why did this stop working for iOS and tvOS
        XCTAssertTrue(textView.currentRichTextTypingAttributeStyles.hasStyle(.italic))
        #endif
        textView.setSelectedRange(noRange)
        XCTAssertFalse(textView.currentRichTextTypingAttributeStyles.hasStyle(.italic))
    }

    func testIsCurrentTextUnderlinedWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextStyleTypingAttributes(.underlined, to: true)
        XCTAssertTrue(textView.currentRichTextTypingAttributeStyles.hasStyle(.underlined))
        textView.setSelectedRange(noRange)
        XCTAssertFalse(textView.currentRichTextTypingAttributeStyles.hasStyle(.underlined))
    }

    func testIsCurrentTextUnderlinedWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentRichTextStyleTypingAttributes(.underlined, to: true)
        #if iOS || os(tvOS)
        XCTAssertTrue(textView.currentRichTextTypingAttributeStyles.hasStyle(.underlined))
        #endif
        textView.setSelectedRange(selectedRange)
        XCTAssertFalse(textView.currentRichTextTypingAttributeStyles.hasStyle(.underlined))
    }
}
#endif
