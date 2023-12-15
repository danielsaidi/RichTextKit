//
//  RichTextViewIntegrationTests.swift
//
//
//  Created by Dominik Bucher on 14.12.2023.
//

#if canImport(UIKit)
import UIKit
#endif

#if macOS
import AppKit
#endif

import RichTextKit
import XCTest

final class RichTextViewIntegrationTests: XCTestCase {
    private var textView: RichTextViewComponent!
        
    override func setUp() {
        super.setUp()
        
        textView = RichTextView()
        textView.setup(
            with: .empty,
            format: .rtf,
            linkColor: .cyan
        )
    }
    
    override func tearDown() {
        textView = nil
        super.tearDown()
    }
    
    func test_behavior() throws {
        // When starting RichTextEditor we want to check if the font and color is set correctly.
        textView.setSelectedRange(.init(location: 0, length: 0))
        print(textView.currentRichTextAttributes)
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.textColor)
        
        let stringWithoutAttributes = "String without any attributes"
        textView.pasteText(stringWithoutAttributes, at: .zero)
               
        textView.setSelectedRange(.init(location: 0, length: stringWithoutAttributes.count))
        textView.setRichTextStyle(.bold, to: true)
        #if macOS
        XCTAssertTrue(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.bold)))
        #elseif canImport(UIKit)
        XCTAssertTrue(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        #endif
        
        textView.setRichTextStyle(.bold, to: false)
        #if macOS
        XCTAssertFalse(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.bold)))
        #elseif canImport(UIKit)
        XCTAssertFalse(try XCTUnwrap(textView.currentFont?.fontDescriptor.symbolicTraits.contains(.traitBold)))
        #endif
    }
}

