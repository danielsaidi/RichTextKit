//
//  RichTextColorTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-23.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

final class RichTextColorTests: XCTestCase {

    func testAllCasesExcludesUndefined() {
        let colors = RichTextColor.allCases
        let expected: [RichTextColor] = [
            .foreground,
            .background,
            .strikethrough,
            .stroke,
            .underline
        ]
        XCTAssertEqual(colors, expected)
    }
}
