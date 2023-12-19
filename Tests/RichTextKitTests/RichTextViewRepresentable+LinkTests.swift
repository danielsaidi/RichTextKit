//
//  RichTextViewRepresentable+LinkTests.swift
//
//
//  Created by Dominik Bucher on 04.12.2023.
//

#if canImport(UIKit)
import UIKit
#endif

#if macOS
import AppKit
#endif

#if os(iOS) || os(macOS) || os(tvOS)
@testable import RichTextKit
import XCTest

class RichTextViewComponent_LinkTests: XCTestCase {
    
    var textView: RichTextViewComponent!
    
    private let noRange = NSRange(location: 0, length: 0)
    private let selectedRange = NSRange(location: 4, length: 3)
    
    override func setUp() {
        super.setUp()
        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz"),
            format: .rtf,
            linkColor: .cyan
        )
    }
    
    override func tearDown() {
        textView = nil
        super.tearDown()
    }
    
    func test_whenSetLinkAtSelectedRange_linkIsSet_colorIsSet() throws {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextLink(URL(string: "https://google.com"))
        // This occurs before processEditing is set, so we ensure that customLink attributes are set.
        let linkAttributes = try XCTUnwrap(textView.currentRichTextAttributes[.customLink] as? CustomLinkAttributes)
        XCTAssertEqual(linkAttributes.link, "https://google.com")
        XCTAssertEqual(linkAttributes.color, ColorRepresentable.cyan)
    }
    
    func test_whenChangesRangeFromLink_linkIsNotSet_colorIsNotSet() throws {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextLink(URL(string: "https://google.com"))
        textView.setSelectedRange(noRange)
        XCTAssertNil(textView.currentRichTextAttributes[.link])
        XCTAssertNil(textView.currentRichTextAttributes[.foregroundColor])
        XCTAssertNil(textView.currentRichTextAttributes[.customLink])
    }
    
    func test_whenUnsetLinkAtSelectedRange_linkIsUnset_colorIsUnset() throws {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextLink(URL(string: "https://google.com"))
        let linkAttributes = try XCTUnwrap(textView.currentRichTextAttributes[.customLink] as? CustomLinkAttributes)
        XCTAssertEqual(linkAttributes.link, "https://google.com")
        XCTAssertEqual(linkAttributes.color, ColorRepresentable.cyan)
        
        textView.setCurrentRichTextLink(nil)
        
        XCTAssertNil(textView.currentRichTextAttributes[.link])
        XCTAssertEqual(try XCTUnwrap(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable), ColorRepresentable.textColor)
        XCTAssertNil(textView.currentRichTextAttributes[.customLink])
    }
}
#endif

