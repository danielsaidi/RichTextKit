//
//  RichTextEditorTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import RichTextKit
import SwiftUI
import XCTest

class RichTextEditorTests: XCTestCase {

    var text: NSAttributedString!
    var textBinding: Binding<NSAttributedString>!
    var editor: RichTextEditor!
    var context: RichTextContext!
    var coordinator: RichTextCoordinator!

    override func setUp() {
        text = NSAttributedString(string: "foo bar baz")
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        context = RichTextContext()
        editor = RichTextEditor(
            text: textBinding,
            context: context)
        coordinator = editor.makeCoordinator()
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
