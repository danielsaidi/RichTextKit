//
//  RichTextViewComponent+AlignmentTests.swift
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

final class RichTextViewComponent_AlignmentTests: XCTestCase {

    private var textView: RichTextViewComponent!

    private let alignment = RichTextAlignment.right
    private let startRange = NSRange(location: 0, length: 1)
    private let selectedRange = NSRange(location: 4, length: 3)
    private let secondRowRange = NSRange(location: 14, length: 3)

    override func setUp() {
        super.setUp()

        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz\nfoo bar baz"),
            format: .rtf
        )
    }

    override func tearDown() {
        textView = nil

        super.tearDown()
    }

    private func assertEqualAlignment(_ attr: Any?) {
        let paragraphAlignment = (attr as? NSMutableParagraphStyle)?.alignment ?? .left
        let align = RichTextAlignment(paragraphAlignment)
        XCTAssertEqual(align, alignment)
    }

    private func assertNonEqualAlignment(_ attr: Any?) {
        let paragraphAlignment = (attr as? NSMutableParagraphStyle)?.alignment ?? .left
        let align = RichTextAlignment(paragraphAlignment)
        XCTAssertNotEqual(align, alignment)
    }

    func testRichTextAlignmentWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setRichTextAlignment(alignment)
        XCTAssertEqual(textView.richTextAlignment, alignment)
        assertEqualAlignment(textView.richTextAttributes[.paragraphStyle])
        assertEqualAlignment(textView.richTextAttributes(at: selectedRange)[.paragraphStyle])
        #if iOS || os(tvOS)
        assertEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif macOS
        assertNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }

    func testRichTextAlignmentSetsAlignmentForEntireParagraph() {
        textView.setSelectedRange(startRange)
        textView.setRichTextAlignment(alignment)
        XCTAssertEqual(textView.richTextAlignment, alignment)
        assertEqualAlignment(textView.richTextAttributes[.paragraphStyle])
        assertEqualAlignment(textView.richTextAttributes(at: selectedRange)[.paragraphStyle])
        #if iOS || os(tvOS)
        assertEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif macOS
        assertNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }

    func testRichTextAlignmentDoesNotSetAlignmentForParagraphsOutsideOfRange() {
        textView.setSelectedRange(startRange)
        textView.setRichTextAlignment(alignment)
        XCTAssertEqual(textView.richTextAlignment, alignment)
        assertEqualAlignment(textView.richTextAttributes[.paragraphStyle])
        assertNonEqualAlignment(textView.richTextAttributes(at: secondRowRange)[.paragraphStyle])
        #if iOS || os(tvOS)
        assertEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif macOS
        assertNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }
}
#endif
