//
//  RichTextAlignmentReaderTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI
import XCTest

final class RichTextAlignmentReaderTests: XCTestCase {

    func testCanReadTextAlignment() throws {
        let textView = RichTextView()
        textView.attributedString = NSAttributedString(string: "foo bar")
        let range = NSRange(location: 2, length: 3)
        textView.selectedRange = range
        textView.setCurrentRichTextAlignment(to: .justified)
        let result = textView.attributedString.richTextAlignment(at: range)
        XCTAssertEqual(result, .justified)
    }
}

private class TestReader: RichTextAlignmentReader {

    var attributedString = NSAttributedString(string: "foo bar")
}
