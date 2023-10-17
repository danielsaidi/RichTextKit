//
//  RichTextAttributeReader+AlignmentTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import RichTextKit
import SwiftUI
import XCTest

final class RichTextAttributeReader_AlignmentTests: XCTestCase {

    func testCanReadTextAlignment() {
        let textView = RichTextView()
        textView.attributedString = NSAttributedString(string: "foo bar")
        let range = NSRange(location: 2, length: 3)
        textView.selectedRange = range
        textView.setCurrentTextAlignment(.justified)
        let result = textView.attributedString.richTextAlignment(at: range)
        XCTAssertEqual(result, .justified)
    }
}

private class TestReader: RichTextAttributeReader {

    var attributedString = NSAttributedString(string: "foo bar")
}
#endif
