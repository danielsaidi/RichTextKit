//
//  NSAttributedString+EmptyTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-31.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class NSAttributedString_EmptyTests: XCTestCase {
    
    func testEmptyAttributedString() {
        let string = NSAttributedString.empty
        XCTAssertEqual(string.string, "")
    }
}
