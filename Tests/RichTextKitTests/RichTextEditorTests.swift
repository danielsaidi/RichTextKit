//
//  RichTextEditorTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS)
import RichTextKit
import SwiftUI
import XCTest

final class RichTextEditorTests: XCTestCase {

    private var text: NSAttributedString!
    private var textBinding: Binding<NSAttributedString>!
    private var editor: RichTextEditor!
    private var context: RichTextContext!
    private var coordinator: RichTextCoordinator!

    override func setUp() {
        super.setUp()

        text = NSAttributedString(string: "foo bar baz")
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        context = RichTextContext()
        editor = RichTextEditor(
            text: textBinding,
            context: context,
            linkColor: .cyan
        )
        coordinator = editor.makeCoordinator()
    }

    override func tearDown() {
        text = nil
        textBinding = nil
        editor = nil
        context = nil
        coordinator = nil

        super.tearDown()
    }

    func testRichTextPresenterUsesContextSelectedRange() {
        let range = NSRange(location: 4, length: 3)
        context.selectRange(range)
        XCTAssertEqual(editor.selectedRange, range)
    }

    func testCoordinatorReturnsCorrectlyConfiguredInstance() {
        let coordinator = editor.makeCoordinator()
        XCTAssertEqual(coordinator.text.wrappedValue.string, text.string)
        XCTAssertTrue(coordinator.textView === editor.textView)
        XCTAssertTrue(coordinator.richTextContext === context)
    }
}
#endif
