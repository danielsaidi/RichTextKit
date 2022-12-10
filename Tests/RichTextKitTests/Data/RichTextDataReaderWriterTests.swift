//
//  RichTextDataReaderWriterTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-01-25.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import UniformTypeIdentifiers
import XCTest

class RichTextDataReaderWriterTests: XCTestCase {

    func testCanGenerateAndParseArchivedData() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextArchivedData() else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(archivedData: data)
        XCTAssertEqual(result?.string, "foo bar baz")
    }

    func testCanGenerateAndParsePlainTextData() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextPlainTextData() else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(plainTextData: data)
        XCTAssertEqual(result?.string, "foo bar baz")
    }

    func testCanGenerateAndParseRtfData() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextRtfData() else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(rtfData: data)
        XCTAssertEqual(result?.string, "foo bar baz")
    }

    func testDataForFormatCanGenerateAndParseArchivedData() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextData(for: .archivedData) else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(data: data, format: .archivedData)
        XCTAssertEqual(result?.string, "foo bar baz")
    }

    func testDataForFormatCanGenerateAndParsePlainTextData() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextData(for: .plainText) else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(data: data, format: .plainText)
        XCTAssertEqual(result?.string, "foo bar baz")
    }

    func testDataForFormatCanGenerateAndParseRtfData() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextData(for: .rtf) else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(data: data, format: .rtf)
        XCTAssertEqual(result?.string, "foo bar baz")
    }
}
