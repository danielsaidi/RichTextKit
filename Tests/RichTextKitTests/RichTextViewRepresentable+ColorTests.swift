//
//  RichTextViewComponent+ColorTests.swift
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

final class RichTextViewComponent_ColorTests: XCTestCase {

    private var textView: RichTextViewComponent!

    private let color = ColorRepresentable.red
    private let noRange = NSRange(location: 0, length: 0)
    private let selectedRange = NSRange(location: 4, length: 3)

    override func setUp() {
        super.setUp()

        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz"),
            format: .rtf
        )
    }

    override func tearDown() {
        textView = nil

        super.tearDown()
    }

    private func assertEqualColor(_ attr: Any?) {
        XCTAssertEqual(attr as? ColorRepresentable, color)
    }

    private func assertNonEqualColor(_ attr: Any?) {
        XCTAssertNotEqual(attr as? ColorRepresentable, color)
    }

    func testRichTextBackgroundColorWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setRichTextColor(.background, to: color)
        XCTAssertEqual(textView.richTextColor(.background), color)
        assertEqualColor(textView.richTextAttributes[.backgroundColor])
        assertEqualColor(textView.richTextAttributes(at: selectedRange)[.backgroundColor])
        assertEqualColor(textView.typingAttributes[.backgroundColor])
    }

    func testRichTextBackgroundColorWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setRichTextColor(.background, to: color)
        #if iOS || os(tvOS)
        XCTAssertEqual(textView.richTextColor(.background), color)
        assertEqualColor(textView.richTextAttributes[.backgroundColor])
        #endif
        XCTAssertNil(textView.richTextAttributes(at: selectedRange)[.backgroundColor])
        assertEqualColor(textView.typingAttributes[.backgroundColor])
    }


    func testRichTextForegroundColorWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setRichTextColor(.foreground, to: color)
        XCTAssertEqual(textView.richTextColor(.foreground), color)
        assertEqualColor(textView.richTextAttributes[.foregroundColor])
        assertEqualColor(textView.richTextAttributes(at: selectedRange)[.foregroundColor])
        assertEqualColor(textView.typingAttributes[.foregroundColor])
    }

    func testRichTextForegroundColorWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setRichTextColor(.foreground, to: color)
        #if iOS || os(tvOS)
        XCTAssertEqual(textView.richTextColor(.foreground), color)
        assertEqualColor(textView.richTextAttributes[.foregroundColor])
        #endif
        let attributes = textView.richTextAttributes(at: selectedRange)
        XCTAssertNotEqual(attributes[.foregroundColor] as? ColorRepresentable, color)
        assertEqualColor(textView.typingAttributes[.foregroundColor])
    }
}
#endif
