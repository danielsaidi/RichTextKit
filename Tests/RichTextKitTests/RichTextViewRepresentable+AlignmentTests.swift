//
//  RichTextViewRepresentable+AlignmentTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
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

class RichTextViewRepresentable_AlignmentTests: XCTestCase {

    var textView: RichTextView!

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

    func validateEqualAlignment(_ attr: Any?) {
        let paragraphAlignment = (attr as? NSMutableParagraphStyle)?.alignment ?? .left
        let align = RichTextAlignment(paragraphAlignment)
        XCTAssertEqual(align, alignment)
    }

    func validateNonEqualAlignment(_ attr: Any?) {
        let paragraphAlignment = (attr as? NSMutableParagraphStyle)?.alignment ?? .left
        let align = RichTextAlignment(paragraphAlignment)
        XCTAssertNotEqual(align, alignment)
    }


    func testCurrentRichTextAlignmentWorksForSelectedRange() {
        textView.selectedRange = selectedRange
        textView.setCurrentRichTextAlignment(to: alignment)
        XCTAssertEqual(textView.currentRichTextAlignment, alignment)
        validateEqualAlignment(textView.currentRichTextAttributes[.paragraphStyle])
        validateEqualAlignment(textView.richTextAttributes(at: selectedRange)[.paragraphStyle])
        #if os(iOS) || os(tvOS)
        validateEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif os(macOS)
        validateNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }

    func testCurrentRichTextAlignmentSetsAlignmentForEntireParagraph() {
        textView.selectedRange = startRange
        textView.setCurrentRichTextAlignment(to: alignment)
        XCTAssertEqual(textView.currentRichTextAlignment, alignment)
        validateEqualAlignment(textView.currentRichTextAttributes[.paragraphStyle])
        validateEqualAlignment(textView.richTextAttributes(at: selectedRange)[.paragraphStyle])
        #if os(iOS) || os(tvOS)
        validateEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif os(macOS)
        validateNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }

    func testCurrentRichTextAlignmentDoesNotSetAlignmentForParagraphsOutsideOfRange() {
        textView.selectedRange = startRange
        textView.setCurrentRichTextAlignment(to: alignment)
        XCTAssertEqual(textView.currentRichTextAlignment, alignment)
        validateEqualAlignment(textView.currentRichTextAttributes[.paragraphStyle])
        validateNonEqualAlignment(textView.richTextAttributes(at: secondRowRange)[.paragraphStyle])
        #if os(iOS) || os(tvOS)
        validateEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #elseif os(macOS)
        validateNonEqualAlignment(textView.typingAttributes[.paragraphStyle])
        #endif
    }
}
#endif
