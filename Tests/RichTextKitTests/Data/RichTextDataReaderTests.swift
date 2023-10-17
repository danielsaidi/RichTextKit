//
//  RichTextDataReaderTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2022-01-25.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import UniformTypeIdentifiers
import XCTest

class RichTextDataReaderWriterTests: XCTestCase {

    func testCanGenerateDataForArchivedFormat() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextData(for: .archivedData) else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(data: data, format: .archivedData)
        XCTAssertEqual(result?.string, "foo bar baz")
    }

    func testCanGenerateDataForPlainTextFormat() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextData(for: .plainText) else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(data: data, format: .plainText)
        XCTAssertEqual(result?.string, "foo bar baz")
    }

    func testCanGenerateDataForRtfFormat() {
        let string = NSAttributedString(string: "foo bar baz")
        guard let data = try? string.richTextData(for: .rtf) else { return XCTFail("Test failed") }
        let result = try? NSAttributedString(data: data, format: .rtf)
        XCTAssertEqual(result?.string, "foo bar baz")
    }
}
