//
//  RichTextCoordinatorTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS)
import SwiftUI
import XCTest

@testable import RichTextKit

final class RichTextCoordinatorTests: XCTestCase {
    private var text: NSAttributedString!
    private var textBinding: Binding<NSAttributedString>!
    private var view: RichTextView!
    private var context: RichTextContext!
    private var coordinator: RichTextCoordinator!

    override func setUp() {
        super.setUp()

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
        view.setRichTextAlignment(.justified)
    }

    override func tearDown() {
        text = nil
        textBinding = nil
        view = nil
        context = nil
        coordinator = nil

        super.tearDown()
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
        XCTAssertEqual(coordinator.context.selectedRange, range)
    }

    func assertIsSyncedWithContext(macOSAlignment: RichTextAlignment = .left) {
        let styles = view.richTextStyles
        XCTAssertEqual(context.fontName, view.richTextFont?.fontName)
        XCTAssertEqual(context.fontSize, view.richTextFont?.pointSize)
        XCTAssertEqual(context.styles[.bold], styles.hasStyle(.bold))
        XCTAssertEqual(context.styles[.italic], styles.hasStyle(.italic))
        XCTAssertEqual(context.styles[.underlined], styles.hasStyle(.underlined))
        XCTAssertEqual(context.selectedRange, view.selectedRange)
        #if iOS || os(tvOS)
        XCTAssertEqual(context.textAlignment, view.richTextAlignment)
        #elseif macOS
        XCTAssertEqual(context.textAlignment, macOSAlignment)
        #endif
    }

    #if iOS || os(tvOS)

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

    #elseif macOS

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
        coordinator.context.highlightedRange = range
        coordinator.highlightedRangeOriginalBackgroundColor = .blue
        coordinator.highlightedRangeOriginalForegroundColor = .yellow
        coordinator.resetHighlightedRangeAppearance()
        view.selectedRange = range
        XCTAssertEqual(view.richTextColor(.background), .blue)
        XCTAssertEqual(view.richTextColor(.foreground), .yellow)
    }
}
#endif
