//
//  RichTextAlignment+PickerTests.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI
import XCTest

@testable import RichTextKit

@MainActor
final class RichTextAlignment_PickerTests: XCTestCase {

    func testCanBeCreatedWithAllParameters() {
        let picker = RichTextAlignment.Picker(
            selection: .constant(.left),
            values: [.left]
        )

        XCTAssertEqual(picker.values, [.left])
    }

    func testCanBeCreatedWithDefaultParameters() {
        let picker = RichTextAlignment.Picker(
            selection: .constant(.left))

        XCTAssertEqual(picker.values, RichTextAlignment.allCases)
    }
}
