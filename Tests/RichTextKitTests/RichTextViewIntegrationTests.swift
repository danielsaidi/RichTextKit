//
//  RichTextViewIntegrationTests.swift
//
//
//  Created by Dominik Bucher on 14.12.2023.
//

#if canImport(UIKit)
import UIKit
#endif

import CoreGraphics
import SwiftUI
@testable import RichTextKit
import XCTest

final class RichTextViewIntegrationTests: XCTestCase {
    private var text: NSAttributedString!
    private var textBinding: Binding<NSAttributedString>!
    private var textView: RichTextView!
    private var textContext: RichTextContext!
    private var coordinator: RichTextCoordinator!
    
    override func setUp() {
        super.setUp()
        
        text = NSAttributedString.empty
        textBinding = Binding(get: { self.text }, set: { self.text = $0 })
        textView = RichTextView(string: text, linkColor: ColorRepresentable.blue)
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
    
    func test_behavior_whenTextViewEmpty() throws {
        // When starting RichTextEditor we want to check if the font and color is set correctly.
        textView.setSelectedRange(.init(location: 0, length: 0))
        
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.textColor)
        
        let stringWithoutAttributes = "String without any attributes"
        textView.replace(
            textView.textRange(
                from: textView.endOfDocument,
                to: textView.endOfDocument)!,
                withText: stringWithoutAttributes
        )
        
        textView.setSelectedRange(.init(location: 0, length: stringWithoutAttributes.count))
        
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.textColor)
        
        textView.setRichTextStyle(.bold, to: true)
        
        XCTAssertTrue(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        
        textView.setRichTextStyle(.bold, to: false)
        XCTAssertFalse(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        
        let otherStringToAppend = ". And This is some text with other attributes!"
        textView.replace(
            textView.textRange(
                from: textView.endOfDocument,
                to: textView.endOfDocument
            )!,
            withText: otherStringToAppend
        )
        
        textView.setSelectedRange(NSRange(location: stringWithoutAttributes.count , length: otherStringToAppend.count))
        let selectedRange = textView.selectedRange
        XCTAssertFalse(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        textView.setRichTextStyle(.strikethrough, to: true, at: selectedRange)
        
        XCTAssertEqual(textView.currentRichTextAttributes[.strikethroughStyle] as? Int, 1)
        XCTAssertEqual(textView.richTextAttributes(at: selectedRange)[.strikethroughStyle] as? Int, 1)
        XCTAssertNil(
            textView.richTextAttributes(
                at: NSRange(location: .zero, length: stringWithoutAttributes.count))[.strikethroughStyle]
        )
        
    }
}
