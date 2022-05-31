//
//  RichTextAlignmentTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI
import XCTest

final class RichTextAlignmentTests: XCTestCase {

    func testCanBeCreatedWithNativeAlignment() throws {
        func result(for alignment: NSTextAlignment) -> RichTextAlignment {
            RichTextAlignment(alignment)
        }

        XCTAssertEqual(result(for: .left), .left)
        XCTAssertEqual(result(for: .right), .right)
        XCTAssertEqual(result(for: .center), .center)
        XCTAssertEqual(result(for: .justified), .justified)
    }

    func testHasValidIdentifier() throws {
        func result(for alignment: NSTextAlignment) -> String {
            RichTextAlignment(alignment).id
        }

        XCTAssertEqual(result(for: .left), "left")
        XCTAssertEqual(result(for: .right), "right")
        XCTAssertEqual(result(for: .center), "center")
        XCTAssertEqual(result(for: .justified), "justified")
    }

    func testHasValidIcon() throws {
        func result(for alignment: NSTextAlignment) -> Image {
            RichTextAlignment(alignment).icon
        }

        XCTAssertEqual(result(for: .left), .alignmentLeft)
        XCTAssertEqual(result(for: .right), .alignmentRight)
        XCTAssertEqual(result(for: .center), .alignmentCenter)
        XCTAssertEqual(result(for: .justified), .alignmentJustified)
    }

    func testHasValidNativeAlignment() throws {
        func result(for alignment: NSTextAlignment) -> NSTextAlignment {
            RichTextAlignment(alignment).nativeAlignment
        }

        XCTAssertEqual(result(for: .left), .left)
        XCTAssertEqual(result(for: .right), .right)
        XCTAssertEqual(result(for: .center), .center)
        XCTAssertEqual(result(for: .justified), .justified)
    }
}
