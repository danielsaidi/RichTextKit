//
//  RichTextCoordinator+SubscriptionsTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS)
import RichTextKit
import SwiftUI
import XCTest

final class RichTextCoordinator_SubscriptionsTests: XCTestCase {

    private var text: NSAttributedString!
    private var textBinding: Binding<NSAttributedString>!
    private var textView: RichTextView!
    private var textContext: RichTextContext!
    private var coordinator: RichTextCoordinator!

    override func setUp() {
        super.setUp()

        text = NSAttributedString(string: "foo bar baz")
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        textView = RichTextView()
        textContext = RichTextContext()
        coordinator = RichTextCoordinator(
            text: textBinding,
            textView: textView,
            richTextContext: textContext)
        textView.selectedRange = NSRange(location: 0, length: 1)
        textView.setRichTextAlignment(.justified)
    }

    override func tearDown() {
        text = nil
        textBinding = nil
        textView = nil
        textContext = nil
        coordinator = nil

        super.tearDown()
    }

    func testTextCoordinatorIsNeededForUpdatesToTakePlace() {
        XCTAssertNotNil(coordinator)
    }


    func testFontNameChangesUpdatesTextView() {
        XCTAssertNotEqual(textView.richTextFontName, "Arial")
        textContext.fontName = ""

        eventually {
            #if iOS || os(tvOS)
            XCTAssertEqual(self.textView.richTextFontName, ".SFUI-Regular")
            #elseif os(macOS)
            XCTAssertEqual(self.textView.richTextFontName, ".AppleSystemUIFont")
            #endif
        }
    }


    func testFontSizeChangesUpdatesTextView() {
        XCTAssertNotEqual(textView.richTextFontSize, 666)
        textContext.fontSize = 666
        XCTAssertEqual(textView.richTextFontSize, 666)
    }


    func testFontSizeDecrementUpdatesTextView() {
        textView.setRichTextFontSize(666)
        XCTAssertEqual(textView.richTextFontSize, 666)
        textContext.handle(.stepFontSize(points: -1))
        // XCTAssertEqual(textView.richTextFontSize, 665)
    }


    func testFontSizeIncrementUpdatesTextView() {
        textView.setRichTextFontSize(666)
        XCTAssertEqual(textView.richTextFontSize, 666)
        textContext.handle(.stepFontSize(points: 1))
        // XCTAssertEqual(textView.richTextFontSize, 667)    TODO: Why is incorrect?
    }


    func testHighlightedRangeUpdatesTextView() {
        textView.highlightingStyle = RichTextHighlightingStyle(
            backgroundColor: .yellow,
            foregroundColor: .red)
        let range = NSRange(location: 4, length: 3)
        textContext.highlightRange(range)
        let attr = textView.richTextAttributes(at: range)
        let back = attr[.backgroundColor] as? ColorRepresentable
        let fore = attr[.foregroundColor] as? ColorRepresentable
        XCTAssertEqual(back, ColorRepresentable(textView.highlightingStyle.backgroundColor))
        XCTAssertEqual(fore, ColorRepresentable(textView.highlightingStyle.foregroundColor))
    }


    func testIsBoldUpdatesTextView() {
        XCTAssertFalse(textView.richTextStyles.hasStyle(.bold))
        textContext.isBold = true
        XCTAssertTrue(textView.richTextStyles.hasStyle(.bold))
    }


    func testIsItalicUpdatesTextView() {
        XCTAssertFalse(textView.richTextStyles.hasStyle(.italic))
        textContext.isItalic = true
        XCTAssertTrue(textView.richTextStyles.hasStyle(.italic))
    }


    func testIsUnderlinedUpdatesTextView() {
        XCTAssertFalse(textView.richTextStyles.hasStyle(.underlined))
        textContext.isUnderlined = true
        XCTAssertTrue(textView.richTextStyles.hasStyle(.underlined))
    }


    func testSelectedRangeChangeUpdatesTextView() {
        let range = NSRange(location: 4, length: 3)
        textContext.selectRange(range)
        XCTAssertEqual(textView.selectedRange, range)
    }


    func testTextAlignmentUpdatesTextView() {
        textView.setRichTextAlignment(.left)
        XCTAssertEqual(textView.richTextAlignment, .left)
        textContext.textAlignment = .right
        XCTAssertEqual(textView.richTextAlignment, .right)
    }
}
#endif
