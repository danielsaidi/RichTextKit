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

final class RichTextAlignment_PickerTests: XCTestCase {

    func testCanBeCreatedWithAllParameters() {
        let picker = RichTextAlignment.Picker(
            selection: .constant(.left),
            style: .init(iconColor: .red),
            values: [.left]
        )

        XCTAssertEqual(picker.style.iconColor, .red)
        XCTAssertEqual(picker.values, [.left])
    }

    func testCanBeCreatedWithDefaultParameters() {
        let picker = RichTextAlignment.Picker(
            selection: .constant(.left))

        XCTAssertEqual(picker.style.iconColor, .primary)
        XCTAssertEqual(picker.values, RichTextAlignment.allCases)
    }
}
