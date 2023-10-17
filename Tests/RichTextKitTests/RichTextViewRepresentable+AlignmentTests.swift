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

#if os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS) || os(tvOS)
import RichTextKit
import XCTest

class RichTextViewComponent_AlignmentTests: XCTestCase {

    var textView: RichTextViewComponent!

    let alignment = RichTextAlignment.right
    let startRange = NSRange(location: 0, length: 1)
    let selectedRange = NSRange(location: 4, length: 3)
    let secondRowRange = NSRange(location: 14, length: 3)

    override func setUp() {
        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz\nfoo bar baz"),
            format: .rtf
        )
    }

    func assertEqualAlignment(_ attr: Any?) {
        let paragraphAlignment = (attr as? NSMutableParagraphStyle)?.alignment ?? .left
        let align = RichTextAlignment(paragraphAlignment)
        XCTAssertEqual(align, alignment)
    }

    func assertNonEqualAlignment(_ attr: Any?) {
        let paragraphAlignment = (attr as? NSMutableParagraphStyle)?.alignment ?? .left
        let align = RichTextAlignment(paragraphAlignment)
        XCTAssertNotEqual(align, alignment)
    }


    func testCurrentRichTextAlignmentWorksForSelectedRange() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentTextAlignment(alignment)
        XCTAssertEqual(textView.currentTextAlignment, alignment)
        assertEqualAlignment(textView.currentRichTextAttributes[.paragraphStyle])
        assertEqualAlignment(textView.richTextAttributes(at: selectedRange)[.paragraphStyle])
        #if os(iOS) || os(tvOS)
        assertEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif os(macOS)
        assertNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }

    func testCurrentRichTextAlignmentSetsAlignmentForEntireParagraph() {
        textView.setSelectedRange(startRange)
        textView.setCurrentTextAlignment(alignment)
        XCTAssertEqual(textView.currentTextAlignment, alignment)
        assertEqualAlignment(textView.currentRichTextAttributes[.paragraphStyle])
        assertEqualAlignment(textView.richTextAttributes(at: selectedRange)[.paragraphStyle])
        #if os(iOS) || os(tvOS)
        assertEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif os(macOS)
        assertNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }

    func testCurrentRichTextAlignmentDoesNotSetAlignmentForParagraphsOutsideOfRange() {
        textView.setSelectedRange(startRange)
        textView.setCurrentTextAlignment(alignment)
        XCTAssertEqual(textView.currentTextAlignment, alignment)
        assertEqualAlignment(textView.currentRichTextAttributes[.paragraphStyle])
        assertNonEqualAlignment(textView.richTextAttributes(at: secondRowRange)[.paragraphStyle])
        #if os(iOS) || os(tvOS)
        assertEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif os(macOS)
        assertNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }
}
#endif
