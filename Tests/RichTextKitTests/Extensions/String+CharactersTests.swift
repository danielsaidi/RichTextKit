//
//  String+CharactersTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class String_CharactersTest: XCTestCase {
    
    func testStringCharactersAreValid() {
        XCTAssertEqual(String.carriageReturn, "\r")
        XCTAssertEqual(String.newLine, "\n")
        XCTAssertEqual(String.tab, "\t")
    }
}
