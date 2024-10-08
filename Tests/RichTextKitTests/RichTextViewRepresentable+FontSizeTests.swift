//
//  RichTextViewComponent+FontSizeTests.swift
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
/*
final class RichTextViewComponent_FontSizeTests: XCTestCase {

    private var textView: RichTextViewComponent!

    private let size: CGFloat = 666
    private let font = FontRepresentable.systemFont(ofSize: 666)
    private let allRange = NSRange(location: 0, length: 11)
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

    func testRichTextFontWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setRichTextFont(font)
        XCTAssertEqual(textView.richTextFont, font)
        XCTAssertEqual(textView.richTextFont?.fontName, font.fontName)
        assertEqualFont(textView.richTextAttribute(.font))
        assertEqualFont(textView.richTextAttributes(at: selectedRange)[.font])
        #if iOS || os(tvOS)
        assertEqualFont(textView.typingAttributes[.font])
        #endif
    }

    func testRichTextFontWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setRichTextFont(font)
        #if iOS || os(tvOS)
        XCTAssertEqual(textView.richTextFont, font)
        XCTAssertEqual(textView.richTextFont?.fontName, font.fontName)
        assertEqualFont(textView.richTextAttribute(.font))
        #endif
        assertNonEqualFont(textView.richTextAttributes(at: selectedRange)[.font])
        assertEqualFont(textView.typingAttributes[.font])
    }

    func testRichTextFontSizeWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setRichTextFontSize(size)
        XCTAssertEqual(textView.richTextFont?.pointSize, size)
        assertEqualFontSize(textView.richTextAttribute(.font))
        assertEqualFontSize(textView.richTextAttributes(at: selectedRange)[.font])
        assertEqualFontSize(textView.typingAttributes[.font], expected: nil)
    }

    func testRichTextFontSizeWorksForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setRichTextFontSize(size)
        #if iOS || os(tvOS)
        XCTAssertEqual(textView.richTextFont?.pointSize, size)
        assertEqualFontSize(textView.richTextAttribute(.font))
        #endif
        assertNonEqualFontSize(textView.richTextAttributes(at: selectedRange)[.font])
        assertEqualFontSize(textView.typingAttributes[.font])
    }
}

private extension RichTextViewComponent_FontSizeTests {
    func assertEqualFont(_ attr: Any?) {
        XCTAssertEqual(attr as? FontRepresentable, font)
    }

    func assertEqualFontSize(_ attr: Any?, expected: CGFloat? = 666) {
        // XCTAssertEqual((attr as? FontRepresentable)?.pointSize, expected)
    }

    func assertNonEqualFont(_ attr: Any?) {
        XCTAssertNotEqual(attr as? FontRepresentable, font)
    }

    func assertNonEqualFontSize(_ attr: Any?) {
        XCTAssertNotEqual((attr as? FontRepresentable)?.pointSize, size)
    }
}
 */
#endif
