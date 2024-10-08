//
//  RichTextViewIntegrationTests+UIKit.swift
//
//
//  Created by Dominik Bucher on 19.1.2024.
//

#if os(iOS)
import UIKit

import CoreGraphics
import SwiftUI
@testable import RichTextKit
import XCTest

/*
final class RichTextViewIntegrationTests: XCTestCase {

    private var text: NSAttributedString!
    private var textBinding: Binding<NSAttributedString>!
    private var textView: RichTextView!
    private var textContext: RichTextContext!
    private var coordinator: RichTextCoordinator!

    private var attributes: RichTextAttributes {
        textView.richTextAttributes
    }

    override func setUp() {
        super.setUp()

        text = NSAttributedString.empty
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        textView = RichTextView(string: text)
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

    private let stringWithoutAttributes = "String without any attributes"
    private let lastStringToAppend = " Last addition..."
    private let otherStringToAppend = ". And This is some text with other attributes!"

    func test_behavior_forFontStyle() throws {
        // When starting RichTextEditor we want to check if the font and color is set correctly.
        textContext.selectRange(.init(location: 0, length: 0))

        let font = attributes[.font] as? FontRepresentable
        XCTAssertEqual(font?.pointSize, 16)
        XCTAssertEqual(attributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.label)

        // First we fill in the empty textView with some text, select it and set bold and italic to it.
        assertFirstTextPart()
        // After that we append more text, asserting that this text carries same attributes as the one
        // before and we change it.
        assertSecondTextPart()
        // Finally, we set typingAttributes before we append last text and check if those typingAttributes
        // are set to our new text.
        assertFinalTextPart()
    }

    private func assertFirstTextPart() {
        textView.simulateTyping(of: stringWithoutAttributes)

        textContext.selectRange(.init(location: 0, length: stringWithoutAttributes.count))

        let font = attributes[.font] as? FontRepresentable
        XCTAssertEqual(font?.pointSize, 16)
        XCTAssertEqual(attributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.label)

        textView.setRichTextStyle(.bold, to: true)
        textView.setRichTextStyle(.italic, to: true)

        XCTAssertTrue(try XCTUnwrap(textView.richTextFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        XCTAssertTrue(try XCTUnwrap(textView.richTextFont?.fontDescriptor.symbolicTraits.contains(.traitItalic)))

        textView.setRichTextStyle(.bold, to: false)
        textView.setRichTextStyle(.italic, to: false)
        XCTAssertFalse(try XCTUnwrap(textView.richTextFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        XCTAssertFalse(try XCTUnwrap(textView.richTextFont?.fontDescriptor.symbolicTraits.contains(.traitItalic)))
    }

    private func assertSecondTextPart() {
        textView.simulateTyping(of: otherStringToAppend)

        textContext.selectRange(NSRange(location: stringWithoutAttributes.count, length: otherStringToAppend.count))
        let selectedRange = textView.selectedRange
        XCTAssertFalse(try XCTUnwrap(textView.richTextFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        textView.setRichTextStyle(.strikethrough, to: true)

        XCTAssertEqual(attributes[.strikethroughStyle] as? Int, 1)
        XCTAssertEqual(textView.richTextAttributes(at: selectedRange)[.strikethroughStyle] as? Int, 1)
        XCTAssertNil(
            textView.richTextAttributes(
                at: NSRange(
                    location: .zero,
                    length: stringWithoutAttributes.count
                )
            )[.strikethroughStyle]
        )

        textContext.selectRange(NSRange(location: 2, length: .zero))
        XCTAssertNil(attributes[.strikethroughStyle])
    }

    private func assertFinalTextPart() {

        textView.setRichTextStyle(.bold, to: true)
        // Refactor replace into type in tests.
        // document this...
        textView.simulateTyping(of: lastStringToAppend)

        XCTAssertTrue(try XCTUnwrap(textView.richTextFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))

        let lastPartLocation = NSRange(
            location: stringWithoutAttributes.count + otherStringToAppend.count,
            length: lastStringToAppend.count
        )

        let fontForLastString = textView.richTextAttributes(at: lastPartLocation)[.font] as? FontRepresentable
        XCTAssertTrue(try XCTUnwrap(fontForLastString?.fontDescriptor.symbolicTraits.contains(.traitBold)))
    }
}
 */
#endif
