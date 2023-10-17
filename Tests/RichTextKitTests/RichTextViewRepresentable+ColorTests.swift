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

#if os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS) || os(tvOS)
import RichTextKit
import XCTest

class RichTextViewComponent_ColorTests: XCTestCase {

    var textView: RichTextViewComponent!

    let color = ColorRepresentable.red
    let noRange = NSRange(location: 0, length: 0)
    let selectedRange = NSRange(location: 4, length: 3)

    override func setUp() {
        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz"),
            format: .rtf
        )
    }

    func assertEqualColor(_ attr: Any?) {
        XCTAssertEqual(attr as? ColorRepresentable, color)
    }

    func assertNonEqualColor(_ attr: Any?) {
        XCTAssertNotEqual(attr as? ColorRepresentable, color)
    }


    func testCurrentBackgroundColorWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentColor(.background, to: color)
        XCTAssertEqual(textView.currentColor(.background), color)
        assertEqualColor(textView.currentRichTextAttributes[.backgroundColor])
        assertEqualColor(textView.richTextAttributes(at: selectedRange)[.backgroundColor])
        assertEqualColor(textView.typingAttributes[.backgroundColor])
    }

    func testCurrentBackgroundColorWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentColor(.background, to: color)
        #if os(iOS) || os(tvOS)
        XCTAssertEqual(textView.currentColor(.background), color)
        assertEqualColor(textView.currentRichTextAttributes[.backgroundColor])
        #endif
        XCTAssertNil(textView.richTextAttributes(at: selectedRange)[.backgroundColor])
        assertEqualColor(textView.typingAttributes[.backgroundColor])
    }


    func testCurrentForegroundColorWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentColor(.foreground, to: color)
        XCTAssertEqual(textView.currentColor(.foreground), color)
        assertEqualColor(textView.currentRichTextAttributes[.foregroundColor])
        assertEqualColor(textView.richTextAttributes(at: selectedRange)[.foregroundColor])
        assertEqualColor(textView.typingAttributes[.foregroundColor])
    }

    func testCurrentForegroundColorWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentColor(.foreground, to: color)
        #if os(iOS) || os(tvOS)
        XCTAssertEqual(textView.currentColor(.foreground), color)
        assertEqualColor(textView.currentRichTextAttributes[.foregroundColor])
        #endif
        XCTAssertNotEqual(textView.richTextAttributes(at: selectedRange)[.foregroundColor] as? ColorRepresentable, color)
        assertEqualColor(textView.typingAttributes[.foregroundColor])
    }
}
#endif
