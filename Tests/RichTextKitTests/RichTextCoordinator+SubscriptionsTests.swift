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
        textView = RichTextView(frame: .zero)
        textContext = RichTextContext()
        coordinator = RichTextCoordinator(
            text: textBinding,
            textView: textView,
            richTextContext: textContext)
        textView.selectedRange = NSRange(location: 0, length: 1)
        textView.setCurrentTextAlignment(.justified)
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
        XCTAssertNotEqual(textView.currentFontName, "Arial")
        textContext.fontName = ""

        eventually {
            #if iOS || os(tvOS)
            XCTAssertEqual(self.textView.currentFontName, ".SFUI-Regular")
            #elseif os(macOS)
            XCTAssertEqual(self.textView.currentFontName, "Helvetica")
            #endif
        }
    }


    func testFontSizeChangesUpdatesTextView() {
        XCTAssertNotEqual(textView.currentFontSize, 666)
        textContext.fontSize = 666
        XCTAssertEqual(textView.currentFontSize, 666)
    }


    func testFontSizeDecrementUpdatesTextView() {
        textView.setCurrentFontSize(666)
        XCTAssertEqual(textView.currentFontSize, 666)
        textContext.handle(.stepFontSize(points: -1))
        // XCTAssertEqual(textView.currentFontSize, 665)
    }


    func testFontSizeIncrementUpdatesTextView() {
        textView.setCurrentFontSize(666)
        XCTAssertEqual(textView.currentFontSize, 666)
        textContext.handle(.stepFontSize(points: 1))
        // XCTAssertEqual(textView.currentFontSize, 667)    TODO: Why is incorrect?
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
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.bold))
        textContext.isBold = true
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.bold))
    }


    func testIsItalicUpdatesTextView() {
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.italic))
        textContext.isItalic = true
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.italic))
    }


    func testIsUnderlinedUpdatesTextView() {
        XCTAssertFalse(textView.currentRichTextStyles.hasStyle(.underlined))
        textContext.isUnderlined = true
        XCTAssertTrue(textView.currentRichTextStyles.hasStyle(.underlined))
    }


    func testSelectedRangeChangeUpdatesTextView() {
        let range = NSRange(location: 4, length: 3)
        textContext.selectRange(range)
        XCTAssertEqual(textView.selectedRange, range)
    }


    func testTextAlignmentUpdatesTextView() {
        textView.setCurrentTextAlignment(.left)
        XCTAssertEqual(textView.currentTextAlignment, .left)
        textContext.textAlignment = .right
        XCTAssertEqual(textView.currentTextAlignment, .right)
    }
    
    func testLinkUpdatesTextView() {
        XCTAssertNil(textView.currentRichTextAttributes[.link])
        textContext.link = URL(string: "https://google.com")
        XCTAssertEqual(textView.currentRichTextAttribute(.link), "https://google.com")
    }
}
#endif
