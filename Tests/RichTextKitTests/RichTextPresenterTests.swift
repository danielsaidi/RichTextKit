//
//  RichTextPresenterTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-06.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class RichTextPresenterTests: XCTestCase {
    
    var text: NSAttributedString!
    
    private var presenter: MockRichTextPresenter!

    override func setUp() {
        text = NSAttributedString(string: "foo bar baz")
        presenter = MockRichTextPresenter(text: text)
    }


    func testTextRangeBeforeCursorReturnsRangeBeforeSelectionStart() {
        presenter.selectedRange = NSRange(location: 4, length: 3)
        let result = presenter.rangeBeforeInputCursor
        let expected = NSRange(location: 0, length: 4)
        XCTAssertEqual(result, expected)
    }


    func testTextRangeAfterCursorReturnsRangeBeforeSelectionStart() {
        presenter.selectedRange = NSRange(location: 4, length: 3)
        let result = presenter.rangeAfterInputCursor
        let expected = NSRange(location: 4, length: 7)
        XCTAssertEqual(result, expected)
    }


    func testRichTextAtRangeUsesAttributedString() {
        let range = NSRange(location: 4, length: 3)
        presenter.selectedRange = range
        let result = presenter.richText(at: range)
        XCTAssertEqual(result.string, "bar")
    }
}

private class MockRichTextPresenter: RichTextPresenter {
    
    init(text: NSAttributedString) {
        self.attributedString = text
        self.selectedRange = NSRange()
    }
    
    var attributedString: NSAttributedString
    
    var selectedRange: NSRange
}
