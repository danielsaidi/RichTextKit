//
//  RichTextViewHighlightingStyleTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-12-06.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class RichTextViewHighlightingStyleTests: XCTestCase {
    
    func testStandardHighlightingStyleIsValid() {
        let style = RichTextHighlightingStyle.standard
        XCTAssertEqual(style.backgroundColor, .clear)
        XCTAssertEqual(style.foregroundColor, .accentColor)
    }
}
