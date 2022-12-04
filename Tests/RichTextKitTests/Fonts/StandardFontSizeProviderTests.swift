//
//  StandardFontSizeProviderTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import RichTextKit
import XCTest

class StandardFontSizeProviderTests: XCTestCase {
    
    func testStandardRichTextFontSize() {
        XCTAssertEqual(CGFloat.standardRichTextFontSize, 16)
        CGFloat.standardRichTextFontSize = .standardRichTextFontSize
    }
}
