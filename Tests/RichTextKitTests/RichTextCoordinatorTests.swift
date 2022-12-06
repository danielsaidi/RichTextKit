//
//  RichTextCoordinatorTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI
import XCTest

@testable import RichTextKit

class RichTextCoordinatorTests: XCTestCase {
    
    var text: NSAttributedString!
    var textBinding: Binding<NSAttributedString>!
    var textView: RichTextView!
    var textContext: RichTextContext!
    var coordinator: RichTextCoordinator!

    override func setUp() {
        text = NSAttributedString(string: "foo bar baz")
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        textView = RichTextView()
        textContext = RichTextContext()
        coordinator = RichTextCoordinator(
            text: textBinding,
            textView: textView,
            richTextContext: textContext)
        textView.selectedRange = NSRange(location: 0, length: 1)
        textView.setCurrentRichTextAlignment(to: .justified)
    }


    func testInitializerSetsUpTextViewText() {
        XCTAssertEqual(textView.richText.string, "foo bar baz")
    }

    func testInitializerSetsUpTextViewDelegate() {
        XCTAssertTrue(textView.delegate === coordinator)
    }


    func testRichTextPresenterUsesNestedTextView() {
        let range = NSRange(location: 4, length: 3)
        textView.selectedRange = range
        XCTAssertEqual(coordinator.text.wrappedValue.string, "foo bar baz")
        XCTAssertEqual(coordinator.richTextContext.selectedRange, range)
    }



    func assertIsSyncedWithContext(macOSAlignment: RichTextAlignment = .left) {
        XCTAssertEqual(textContext.fontName, textView.currentFontName)
        XCTAssertEqual(textContext.fontSize, textView.currentFontSize)
        XCTAssertEqual(textContext.isBold, textView.currentRichTextStyles.hasStyle(.bold))
        XCTAssertEqual(textContext.isItalic, textView.currentRichTextStyles.hasStyle(.italic))
        XCTAssertEqual(textContext.isUnderlined, textView.currentRichTextStyles.hasStyle(.underlined))
        XCTAssertEqual(textContext.selectedRange, textView.selectedRange)
        #if os(iOS) || os(tvOS)
        XCTAssertEqual(textContext.alignment, textView.currentRichTextAlignment)
        #elseif os(macOS)
        XCTAssertEqual(textContext.alignment, macOSAlignment)
        #endif
    }


    #if os(iOS) || os(tvOS)

    func testTextViewDelegateHandlesTextViewDidBeginEditing() {
        coordinator.textViewDidBeginEditing(textView)
        XCTAssertTrue(textContext.isEditingText)
    }

    func testTextViewDelegateHandlesTextViewDidChange() {
        textView.text = "abc 123"
        coordinator.textViewDidChange(textView)
        assertIsSyncedWithContext()
    }

    func testTextViewDelegateHandlesTextViewDidChangeSelection() {
        coordinator.textViewDidChangeSelection(textView)
        assertIsSyncedWithContext()
    }

    func testTextViewDelegateHandlesTextViewDidEndEditing() {
        textContext.isEditingText = true
        coordinator.textViewDidEndEditing(textView)
        XCTAssertFalse(textContext.isEditingText)
    }

    #elseif os(macOS)

    let notification = Notification(
        name: NSText.didEndEditingNotification,
        object: nil,
        userInfo: [:])

    func testTextViewDelegateHandlesTextDidBeginEditing() {
        coordinator.textDidBeginEditing(notification)
        XCTAssertTrue(textContext.isEditingText)
    }

    func testTextViewDelegateHandlesTextViewDidChangeSelection() {
        coordinator.textViewDidChangeSelection(notification)
        assertIsSyncedWithContext(macOSAlignment: .justified)
    }

    func testTextViewDelegateHandlesTextDidEndEditing() {
        textContext.isEditingText = true
        coordinator.textDidEndEditing(notification)
        XCTAssertFalse(textContext.isEditingText)
    }

    #endif

    func testResetingHighlightedRangeAppearanceResetsToInternalValues() {
        let range = NSRange(location: 4, length: 3)
        coordinator.richTextContext.highlightedRange = range
        coordinator.highlightedRangeOriginalBackgroundColor = .blue
        coordinator.highlightedRangeOriginalForegroundColor = .yellow
        coordinator.resetHighlightedRangeAppearance()
        textView.selectedRange = range
        XCTAssertEqual(textView.currentBackgroundColor, .blue)
        XCTAssertEqual(textView.currentForegroundColor, .yellow)
    }
}
#endif
