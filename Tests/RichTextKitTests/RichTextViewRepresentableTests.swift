//
//  RichTextViewComponentTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-06.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import RichTextKit
import XCTest

class RichTextViewComponentTests: XCTestCase {

    var view: RichTextView!

    override func setUp() {
        view = RichTextView()
    }


    func testHighlightingStyleIsStandardByDefault() {
        XCTAssertEqual(view.highlightingStyle, .standard)
    }


    func testAttributedStringIsProperlySetAndRetrieved() {
        let string = NSAttributedString(string: "foo bar baz")
        view.attributedString = string
        XCTAssertEqual(view.attributedString.string, "foo bar baz")
    }


    func testTextisProperlyRetrieved() {
        let string = NSAttributedString(string: "foo bar baz")
        view.attributedString = string
        XCTAssertEqual(view.richText.string, "foo bar baz")
    }


    func testSettingUpWithEmptyTextWorks() {
        let string = NSAttributedString(string: "")
        view.setup(with: string, format: .rtf)
        XCTAssertEqual(view.richText.string, "")
        #if os(iOS) || os(tvOS)
        XCTAssertFalse(view.allowsEditingTextAttributes)
        XCTAssertEqual(view.autocapitalizationType, .sentences)
        #endif
        XCTAssertEqual(view.backgroundColor, .clear)
        XCTAssertEqual(view.contentCompressionResistancePriority(for: .horizontal), .defaultLow)
        #if os(iOS) || os(tvOS)
        XCTAssertEqual(view.spellCheckingType, .no)
        XCTAssertEqual(view.textColor, .label)
        #elseif os(macOS)
        XCTAssertEqual(view.textColor, .textColor)
        #endif
    }

    func testSettingUpWithNonEmptyTextWorks() {
        let string = NSAttributedString(string: "foo bar baz")
        view.setup(with: string, format: .rtf)
        XCTAssertEqual(view.richText.string, "foo bar baz")
        #if os(iOS) || os(tvOS)
        XCTAssertFalse(view.allowsEditingTextAttributes)
        XCTAssertEqual(view.autocapitalizationType, .sentences)
        #endif
        XCTAssertEqual(view.backgroundColor, .clear)
        XCTAssertEqual(view.contentCompressionResistancePriority(for: .horizontal), .defaultLow)
        #if os(iOS) || os(tvOS)
        XCTAssertEqual(view.spellCheckingType, .no)
        XCTAssertEqual(view.textColor, nil)
        #elseif os(macOS)
        XCTAssertEqual(view.textColor, nil)
        #endif
    }
}
#endif
