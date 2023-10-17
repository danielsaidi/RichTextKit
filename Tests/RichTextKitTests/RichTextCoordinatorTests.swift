//
//  RichTextCoordinatorTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI
import XCTest

@testable import RichTextKit

class RichTextCoordinatorTests: XCTestCase {
    
    var text: NSAttributedString!
    var textBinding: Binding<NSAttributedString>!
    var view: RichTextView!
    var context: RichTextContext!
    var coordinator: RichTextCoordinator!

    override func setUp() {
        text = NSAttributedString(string: "foo bar baz")
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        view = RichTextView()
        context = RichTextContext()
        coordinator = RichTextCoordinator(
            text: textBinding,
            textView: view,
            richTextContext: context)
        coordinator.shouldDelaySyncContextWithTextView = false
        view.selectedRange = NSRange(location: 0, length: 1)
        view.setCurrentTextAlignment(.justified)
    }


    func testInitializerSetsUpTextViewText() {
        XCTAssertEqual(view.richText.string, "foo bar baz")
    }

    func testInitializerSetsUpTextViewDelegate() {
        XCTAssertTrue(view.delegate === coordinator)
    }


    func testRichTextPresenterUsesNestedTextView() {
        let range = NSRange(location: 4, length: 3)
        view.selectedRange = range
        XCTAssertEqual(coordinator.text.wrappedValue.string, "foo bar baz")
        XCTAssertEqual(coordinator.richTextContext.selectedRange, range)
    }



    func assertIsSyncedWithContext(macOSAlignment: RichTextAlignment = .left) {
        XCTAssertEqual(context.fontName, view.currentFontName)
        XCTAssertEqual(context.fontSize, view.currentFontSize)
        XCTAssertEqual(context.isBold, view.currentRichTextStyles.hasStyle(.bold))
        XCTAssertEqual(context.isItalic, view.currentRichTextStyles.hasStyle(.italic))
        XCTAssertEqual(context.isUnderlined, view.currentRichTextStyles.hasStyle(.underlined))
        XCTAssertEqual(context.selectedRange, view.selectedRange)
        #if os(iOS) || os(tvOS)
        XCTAssertEqual(context.textAlignment, view.currentTextAlignment)
        #elseif os(macOS)
        XCTAssertEqual(context.textAlignment, macOSAlignment)
        #endif
    }


    #if os(iOS) || os(tvOS)

    func testTextViewDelegateHandlesTextViewDidBeginEditing() {
        coordinator.textViewDidBeginEditing(view)
        XCTAssertTrue(context.isEditingText)
    }

    func testTextViewDelegateHandlesTextViewDidChange() {
        view.text = "abc 123"
        coordinator.textViewDidChange(view)
        assertIsSyncedWithContext()
    }

    func testTextViewDelegateHandlesTextViewDidChangeSelection() {
        coordinator.textViewDidChangeSelection(view)
        assertIsSyncedWithContext()
    }

    func testTextViewDelegateHandlesTextViewDidEndEditing() {
        context.isEditingText = true
        coordinator.textViewDidEndEditing(view)
        XCTAssertFalse(context.isEditingText)
    }

    #elseif os(macOS)

    let notification = Notification(
        name: NSText.didEndEditingNotification,
        object: nil,
        userInfo: [:])

    func testTextViewDelegateHandlesTextDidBeginEditing() {
        coordinator.textDidBeginEditing(notification)
        XCTAssertTrue(context.isEditingText)
    }

    func testTextViewDelegateHandlesTextViewDidChangeSelection() {
        coordinator.textViewDidChangeSelection(notification)
        assertIsSyncedWithContext(macOSAlignment: .justified)
    }

    func testTextViewDelegateHandlesTextDidEndEditing() {
        context.isEditingText = true
        coordinator.textDidEndEditing(notification)
        XCTAssertFalse(context.isEditingText)
    }

    #endif

    func testResetingHighlightedRangeAppearanceResetsToInternalValues() {
        let range = NSRange(location: 4, length: 3)
        coordinator.richTextContext.highlightedRange = range
        coordinator.highlightedRangeOriginalBackgroundColor = .blue
        coordinator.highlightedRangeOriginalForegroundColor = .yellow
        coordinator.resetHighlightedRangeAppearance()
        view.selectedRange = range
        XCTAssertEqual(view.currentColor(.background), .blue)
        XCTAssertEqual(view.currentColor(.foreground), .yellow)
    }
}
#endif
