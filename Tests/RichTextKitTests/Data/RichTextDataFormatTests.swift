//
//  RichTextDataFormatTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-01-25.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import UniformTypeIdentifiers
import XCTest

class RichTextDataFormatTests: XCTestCase {

    func formatResult(for format: RichTextDataFormat) -> [RichTextDataFormat] {
        format.convertableFormats
    }

    func extensionResult(for format: RichTextDataFormat) -> String {
        format.standardFileExtension
    }

    func imageResult(for format: RichTextDataFormat) -> Bool {
        format.supportsImages
    }

    func uniformTypeResult(for format: RichTextDataFormat) -> UTType {
        format.uniformType
    }


    func testConvertableFormatsAreValidForAllFormats() {
        XCTAssertEqual(formatResult(for: .archivedData), [.rtf, .plainText])
        XCTAssertEqual(formatResult(for: .plainText), [.archivedData, .rtf])
        XCTAssertEqual(formatResult(for: .rtf), [.archivedData, .plainText])
    }

    func testStandardFileExtensionIsValidForAllFormats() {
        XCTAssertEqual(extensionResult(for: .archivedData), "rtk")
        XCTAssertEqual(extensionResult(for: .plainText), "txt")
        XCTAssertEqual(extensionResult(for: .rtf), "rtf")
    }

    func testSupportsImagesIsValidForAllFormats() {
        XCTAssertTrue(imageResult(for: .archivedData))
        XCTAssertFalse(imageResult(for: .plainText))
        XCTAssertFalse(imageResult(for: .rtf))
    }

    func testUniformTypeIsValidForAllFormats() {
        XCTAssertEqual(uniformTypeResult(for: .archivedData), .archivedData)
        XCTAssertEqual(uniformTypeResult(for: .plainText), .plainText)
        XCTAssertEqual(uniformTypeResult(for: .rtf), .rtf)
    }
}
