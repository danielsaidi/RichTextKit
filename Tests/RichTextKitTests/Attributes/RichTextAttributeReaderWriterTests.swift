//
//  RichTextAttributeReaderWriterTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class RichTextAttributeReaderWriterTests: XCTestCase {

    let string = NSMutableAttributedString(string: "foo bar baz")

    func testSettingAttributeWithinRangeOnlySetsAttributeWithinTheProvidedRange() {
        let color = ColorRepresentable.yellow
        let range = NSRange(location: 4, length: 3)
        let noRange = NSRange(location: 0, length: 0)
        string.setRichTextAttribute(.foregroundColor, to: color, at: range)

        let attr1: ColorRepresentable? = string.richTextAttribute(.foregroundColor, at: range)
        XCTAssertEqual(attr1, color)
        let attr2: ColorRepresentable? = string.richTextAttribute(.foregroundColor, at: noRange)
        XCTAssertNil(attr2)

        XCTAssertEqual(string.richTextAttributes(at: range)[.foregroundColor] as? ColorRepresentable, color)
        XCTAssertNil(string.richTextAttributes(at: noRange)[.foregroundColor] as? ColorRepresentable)
    }
}
