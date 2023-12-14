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
    
    func test_behaviour() {
        // set cursor at starting point.
        textView.setSelectedRange(.init(location: 0, length: 0))
        print(textView.currentRichTextAttributes)
        XCTAssertEqual(textView.currentRichTextAttributes[.font] as? FontRepresentable, FontRepresentable.systemFont(ofSize: 16))
        XCTAssertEqual(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable, ColorRepresentable.textColor)
    }
}

