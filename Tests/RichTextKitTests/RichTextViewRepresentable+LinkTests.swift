//
//  RichTextViewRepresentable+LinkTests.swift
//
//
//  Created by Dominik Bucher on 04.12.2023.
//

#if canImport(UIKit)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

#if os(iOS) || os(macOS) || os(tvOS)
import RichTextKit
import XCTest

class RichTextViewComponent_LinkTests: XCTestCase {
    
    var textView: RichTextViewComponent!
    
    let noRange = NSRange(location: 0, length: 0)
    let selectedRange = NSRange(location: 4, length: 3)
    
    override func setUp() {
        textView = RichTextView()
        textView.setup(
            with: NSAttributedString(string: "foo bar baz"),
            format: .rtf,
            linkColor: .cyan
        )
    }
    
    func test_whenSetLinkAtSelectedRange_linkIsSet_colorIsSet() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextLink(URL(string: "https://google.com"), previousLink: nil)
        XCTAssertEqual(try XCTUnwrap(textView.currentRichTextAttributes[.link] as? String), "https://google.com")
        XCTAssertEqual(try XCTUnwrap(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable), UIColor.cyan)
    }
    
    func test_whenChangesRangeFromLink_linkIsNotSet_colorIsNotSet() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextLink(URL(string: "https://google.com"), previousLink: nil)
        textView.setSelectedRange(noRange)
        XCTAssertNil(textView.currentRichTextAttributes[.link])
        XCTAssertNil(textView.currentRichTextAttributes[.foregroundColor])
    }
    
    func test_whenUnsetLinkAtSelectedRange_linkIsUnset_colorIsUnset() {
        textView.setSelectedRange(selectedRange)
        textView.setCurrentRichTextLink(URL(string: "https://google.com"), previousLink: nil)
        XCTAssertEqual(try XCTUnwrap(textView.currentRichTextAttributes[.link] as? String), "https://google.com")
        XCTAssertEqual(try XCTUnwrap(textView.currentRichTextAttributes[.foregroundColor] as? ColorRepresentable), UIColor.cyan)
        
        textView.setCurrentRichTextLink(nil, previousLink: URL(string: "https://google.com"))
        
        XCTAssertNil(textView.currentRichTextAttributes[.link])
        XCTAssertNil(textView.currentRichTextAttributes[.foregroundColor])
    }
}
#endif

