//
//  RichTextViewEmptyIntegrationTests.swift
//
//
//  Created by Dominik Bucher on 14.12.2023.
//

#if os(iOS)
import UIKit

import CoreGraphics
import SwiftUI
@testable import RichTextKit
import XCTest

final class RichTextViewEmptyIntegrationTests: XCTestCase {
    private var text: NSAttributedString!
    private var textBinding: Binding<NSAttributedString>!
    private var textView: RichTextView!
    private var textContext: RichTextContext!
    private var coordinator: RichTextCoordinator!
    
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
        textView.selectedRange = NSRange(location: 0, length: 0)
        textView.setup(with: text, format: .plainText)
    }
    
    override func tearDown() {
        text = nil
        textBinding = nil
        textView = nil
        textContext = nil
        coordinator = nil
        
        super.tearDown()
    }
    
    private let firstTypingPart = "String without any attributes"
    private let secondTypingPart = " Last addition..."
    private let lastTypingPart = ". And This is some text with other attributes!"
    
    func test_behavior_forFontStyle() throws {
        // When starting RichTextEditor we want to check if the font and color is set correctly.
        textContext.selectRange(.init(location: 0, length: 0))
        
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.textColor)
        
        // First we fill in the empty textView with some text, select it and set bold and italic to it.
        assertStyleFirstTextPart()
        // After that we append more text, asserting that this text carries same attributes as the one before
        // and we change it.
        assertStyleSecondTextPart()
        // Finally, we set typingAttributes before we append last text and check if those typingAttributes are set to our
        // new text.
        assertStyleFinalTextPart()
    }
    
    func test_behavior_for_attributes() {
        textContext.selectRange(.init(location: 0, length: 0))
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.textColor)
        
        textView.setCurrentFontSize(36)
        XCTAssertEqual(textView.currentFontSize, 36)
        
        // MARK: First part
        textView.simulateTyping(of: firstTypingPart)
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 36))
        textContext.selectRange(.init(location: 0, length: firstTypingPart.count))
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 36))
        
        textView.setCurrentFontSize(16)
        textView.setRichTextFontName("Arial", at: textView.richTextFullRange)
        RichTextColor.allCases.forEach { type in
            textView.setRichTextColor(
                type,
                to: ColorRepresentable.blue,
                at: textView.richTextFullRange
            )
        }
        
    
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, .blue)
        XCTAssertEqual(textView.currentRichTextAttributes[.backgroundColor] as? ColorRepresentable, .blue)
        XCTAssertEqual(textView.currentRichTextAttributes[.strikethroughColor] as? ColorRepresentable, .blue)
        XCTAssertEqual(textView.currentRichTextAttributes[.underlineColor] as? ColorRepresentable, .blue)
        
        XCTAssertEqual(textView.typingAttributes[.foregroundColor] as? ColorRepresentable, .blue)
        XCTAssertEqual(textView.typingAttributes[.backgroundColor] as? ColorRepresentable, .blue)
        XCTAssertEqual(textView.typingAttributes[.strikethroughColor] as? ColorRepresentable, .blue)
        XCTAssertEqual(textView.typingAttributes[.underlineColor] as? ColorRepresentable, .blue)
        
        XCTAssertEqual(textView.currentFontSize, 16)
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, UIFont(name: "Arial", size: 16))
        
        textView.stepRichTextFontSize(points: 1, at: textView.selectedRange)
        XCTAssertEqual(textView.currentFontSize, 17)
        
        textView.moveInputCursor(to: 0)
        XCTAssertEqual(textView.selectedRange, .init(location: 0, length: 0))
        
        assertParagraphStyle()
    }
}

extension RichTextViewEmptyIntegrationTests {
    private func assertParagraphStyle() {
        let alignmentParagraphs: [NSParagraphStyle] = NSTextAlignment.allCases.map { alignment in
            let style = NSMutableParagraphStyle()
            style.alignment = alignment
            return style
        }
      
        textContext.selectRange(textView.richTextFullRange)
        
        alignmentParagraphs.forEach { paragraph in
            textView.setRichTextAttribute(.paragraphStyle, to: paragraph, at: textView.richTextFullRange)
            XCTAssertEqual((textView.currentRichTextAttributes[.paragraphStyle] as? NSParagraphStyle)?.alignment, paragraph.alignment)
        }
    }
    
    private func assertStyleFirstTextPart() {
        textView.simulateTyping(of: firstTypingPart)
        
        textContext.selectRange(.init(location: 0, length: firstTypingPart.count))
        
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.textColor)
        
        textView.setRichTextStyle(.bold, to: true, at: textView.richTextFullRange)
        textView.setRichTextStyle(.italic, to: true, at: textView.richTextFullRange)
        
        XCTAssertTrue(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        XCTAssertTrue(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitItalic)))
        
        textView.setRichTextStyle(.bold, to: false, at: textView.richTextFullRange)
        textView.setRichTextStyle(.italic, to: false, at: textView.richTextFullRange)
        XCTAssertFalse(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        XCTAssertFalse(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitItalic)))
    }
    
    private func assertStyleSecondTextPart() {
        textView.simulateTyping(of: lastTypingPart)
        
        textContext.selectRange(NSRange(location: firstTypingPart.count , length: lastTypingPart.count))
        let selectedRange = textView.selectedRange
        XCTAssertFalse(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        textView.setRichTextStyle(.strikethrough, to: true, at: selectedRange)
        
        XCTAssertEqual(textView.currentRichTextAttributes[.strikethroughStyle] as? Int, 1)
        XCTAssertEqual(textView.richTextAttributes(at: selectedRange)[.strikethroughStyle] as? Int, 1)
        XCTAssertNil(
            textView.richTextAttributes(at: NSRange(location: .zero, length: firstTypingPart.count))[.strikethroughStyle]
        )
        
        textContext.selectRange(NSRange(location: 2 , length: .zero))
        XCTAssertNil(textView.currentRichTextAttributes[.strikethroughStyle])
    }
    
    private func assertStyleFinalTextPart() {
        textView.setCurrentRichTextStyleTypingAttributes(.bold, to: true)
        textView.simulateTyping(of: secondTypingPart)
        
        XCTAssertTrue(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        
        let lastPartLocation = NSRange(
            location: firstTypingPart.count + lastTypingPart.count,
            length: secondTypingPart.count
        )
        
        let fontForLastString = textView.richTextAttributes(at: lastPartLocation)[.font] as? FontRepresentable
        XCTAssertTrue(try XCTUnwrap(fontForLastString?.fontDescriptor.symbolicTraits.contains(.traitBold)))
    }
}

extension NSTextAlignment: CaseIterable {
    public static var allCases: [NSTextAlignment] {
        [.natural, .justified, .left, .right, .center]
    }
}
#endif
