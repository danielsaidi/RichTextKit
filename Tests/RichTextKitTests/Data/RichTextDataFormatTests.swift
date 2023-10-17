//
//  RichTextDataFormatTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-01-25.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import UniformTypeIdentifiers
import XCTest

class RichTextDataFormatTests: XCTestCase {

    let vendorType = UTType(exportedAs: "fooType")

    lazy var vendorFormat = RichTextDataFormat.vendorArchivedData(
        id: "foo",
        fileExtension: "fooFile",
        fileFormatText: "Foo File (*.foo)",
        uniformType: vendorType
    )

    func idResult(for format: RichTextDataFormat) -> String {
        format.id
    }

    func isArchivedDataResult(for format: RichTextDataFormat) -> Bool {
        format.isArchivedDataFormat
    }

    func formatResult(for format: RichTextDataFormat) -> [RichTextDataFormat] {
        format.convertibleFormats
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


    func testLibraryFormatsReturnAllNonVendorFormats() {
        XCTAssertEqual(RichTextDataFormat.libraryFormats, [.archivedData, .plainText, .rtf])
    }


    func testIdIsValidForAllFormats() {
        XCTAssertEqual(idResult(for: .archivedData), "archivedData")
        XCTAssertEqual(idResult(for: .plainText), "plainText")
        XCTAssertEqual(idResult(for: .rtf), "rtf")
        XCTAssertEqual(idResult(for: vendorFormat), "foo")
    }

    func testArchivedFormatsCanBeDetected() {
        XCTAssertEqual(isArchivedDataResult(for: .archivedData), true)
        XCTAssertEqual(isArchivedDataResult(for: .plainText), false)
        XCTAssertEqual(isArchivedDataResult(for: .rtf), false)
        XCTAssertEqual(isArchivedDataResult(for: vendorFormat), true)
    }

    func testConvertableFormatsAreValidForAllFormats() {
        XCTAssertEqual(formatResult(for: .archivedData), [.plainText, .rtf])
        XCTAssertEqual(formatResult(for: .plainText), [.archivedData, .rtf])
        XCTAssertEqual(formatResult(for: .rtf), [.archivedData, .plainText])
        XCTAssertEqual(formatResult(for: vendorFormat), [.plainText, .rtf])
    }

    func testStandardFileExtensionIsValidForAllFormats() {
        XCTAssertEqual(extensionResult(for: .archivedData), "rtk")
        XCTAssertEqual(extensionResult(for: .plainText), "txt")
        XCTAssertEqual(extensionResult(for: .rtf), "rtf")
        XCTAssertEqual(extensionResult(for: vendorFormat), "fooFile")
    }

    func testSupportsImagesIsValidForAllFormats() {
        XCTAssertTrue(imageResult(for: .archivedData))
        XCTAssertFalse(imageResult(for: .plainText))
        XCTAssertFalse(imageResult(for: .rtf))
        XCTAssertEqual(extensionResult(for: vendorFormat), "fooFile")
    }

    func testUniformTypeIsValidForAllFormats() {
        XCTAssertEqual(uniformTypeResult(for: .archivedData), .archivedData)
        XCTAssertEqual(uniformTypeResult(for: .plainText), .plainText)
        XCTAssertEqual(uniformTypeResult(for: .rtf), .rtf)
        XCTAssertEqual(uniformTypeResult(for: vendorFormat), vendorType)
    }
}
