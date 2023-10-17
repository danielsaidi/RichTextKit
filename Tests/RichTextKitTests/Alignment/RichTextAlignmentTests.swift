//
//  RichTextAlignmentTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI
import XCTest

final class RichTextAlignmentTests: XCTestCase {

    func testCanBeCreatedWithNativeAlignment() {
        func result(for alignment: NSTextAlignment) -> RichTextAlignment {
            RichTextAlignment(alignment)
        }

        XCTAssertEqual(result(for: .left), .left)
        XCTAssertEqual(result(for: .right), .right)
        XCTAssertEqual(result(for: .center), .center)
        XCTAssertEqual(result(for: .justified), .justified)
    }

    func testHasValidIdentifier() {
        func result(for alignment: NSTextAlignment) -> String {
            RichTextAlignment(alignment).id
        }

        XCTAssertEqual(result(for: .left), "left")
        XCTAssertEqual(result(for: .right), "right")
        XCTAssertEqual(result(for: .center), "center")
        XCTAssertEqual(result(for: .justified), "justified")
    }

    func testHasValidIcon() {
        func result(for alignment: NSTextAlignment) -> Image {
            RichTextAlignment(alignment).icon
        }

        XCTAssertEqual(result(for: .left), .richTextAlignmentLeft)
        XCTAssertEqual(result(for: .right), .richTextAlignmentRight)
        XCTAssertEqual(result(for: .center), .richTextAlignmentCenter)
        XCTAssertEqual(result(for: .justified), .richTextAlignmentJustified)
    }

    func testHasValidNativeAlignment() {
        func result(for alignment: NSTextAlignment) -> NSTextAlignment {
            RichTextAlignment(alignment).nativeAlignment
        }

        XCTAssertEqual(result(for: .left), .left)
        XCTAssertEqual(result(for: .right), .right)
        XCTAssertEqual(result(for: .center), .center)
        XCTAssertEqual(result(for: .justified), .justified)
    }
}
