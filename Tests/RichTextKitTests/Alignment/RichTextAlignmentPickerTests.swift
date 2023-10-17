//
//  RichTextAlignmentPickerTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI
import XCTest

@testable import RichTextKit

final class RichTextAlignmentPickerTests: XCTestCase {

    func testCanBeCreatedWithAllParameters() {
        let picker = RichTextAlignmentPicker(
            selection: .constant(.left),
            values: [.left]
        )

        XCTAssertEqual(picker.values, [.left])
    }

    func testCanBeCreatedWithDefaultParameters() {
        let picker = RichTextAlignmentPicker(
            selection: .constant(.left))

        XCTAssertEqual(picker.values, RichTextAlignment.allCases)
    }
}
