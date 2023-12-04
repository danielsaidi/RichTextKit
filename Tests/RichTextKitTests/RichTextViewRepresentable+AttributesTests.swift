//
//  RichTextViewComponent+AttributesTests.swift
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

final class RichTextViewComponent_AttributesTests: XCTestCase {

    private var textView: RichTextViewComponent!

    private let font = FontRepresentable.systemFont(ofSize: 666)
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

    func testTextAttributesIsValidForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextAttribute(.font, to: font)
        assertEqualAttributes(textView.currentRichTextAttributes)
        assertEqualAttributes(textView.richTextAttributes(at: selectedRange))
        assertEqualAttributes(textView.typingAttributes)
    }

    func testTextAttributesIsValidForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentRichTextAttribute(.font, to: font)
        #if iOS || os(tvOS)
        assertEqualAttributes(textView.currentRichTextAttributes)
        #endif
        assertNonEqualAttributes(textView.richTextAttributes(at: selectedRange))
        assertEqualAttributes(textView.typingAttributes)
    }


    func testTextAttributeValueForKeyIsValidForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextAttribute(.font, to: font)
        assertEqualAttribute(textView.currentRichTextAttribute(.font))
        assertEqualAttribute(textView.richTextAttribute(.font, at: selectedRange))
        assertEqualAttribute(textView.typingAttributes[.font])
    }

    func testTextAttributeValueForKeyIsValidForNoSelectedRange() {
        textView.setSelectedRange(noRange)
        textView.setCurrentRichTextAttribute(.font, to: font)
        #if iOS || os(tvOS)
        assertEqualAttribute(textView.currentRichTextAttribute(.font))
        #endif
        assertNonEqualAttribute(textView.richTextAttribute(.font, at: selectedRange))
        assertEqualAttribute(textView.typingAttributes[.font])
    }
}

private extension RichTextViewComponent_AttributesTests {
    func assertEqualAttribute(_ attr: Any?) {
        XCTAssertEqual(attr as? FontRepresentable, font)
    }

    func assertEqualAttributes(_ attr: [NSAttributedString.Key: Any]) {
        assertEqualAttribute(attr[.font])
    }

    func assertNonEqualAttribute(_ attr: Any?) {
        XCTAssertNotEqual(attr as? FontRepresentable, font)
    }

    func assertNonEqualAttributes(_ attr: [NSAttributedString.Key: Any]) {
        assertNonEqualAttribute(attr[.font])
    }
}

#endif
