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
            format: .rtf,
            linkColor: .cyan
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
        #if iOS || os(tvOS)
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
        #if iOS || os(tvOS)
        XCTAssertEqual(textView.currentColor(.foreground), color)
        assertEqualColor(textView.currentRichTextAttributes[.foregroundColor])
        #endif
        XCTAssertNotEqual(textView.richTextAttributes(at: selectedRange)[.foregroundColor] as? ColorRepresentable, color)
        assertEqualColor(textView.typingAttributes[.foregroundColor])
    }
}
#endif
