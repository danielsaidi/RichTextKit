//
//  RichTextAlignmentPickerTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI
import XCTest

final class RichTextAlignmentPickerTests: XCTestCase {

    func testCanBeCreatedWithAllParameters() throws {
        let picker = RichTextAlignmentPicker(
            title: "Test",
            values: [.left],
            selection: .constant(.left))

        XCTAssertEqual(picker.title, "Test")
        XCTAssertEqual(picker.alignments, [.left])
    }

    func testCanBeCreatedWithDefaultParameters() throws {
        let picker = RichTextAlignmentPicker(
            selection: .constant(.left))

        XCTAssertEqual(picker.title, "")
        XCTAssertEqual(picker.alignments, RichTextAlignment.allCases)
    }
}
