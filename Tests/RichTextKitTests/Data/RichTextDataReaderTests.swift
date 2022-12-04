//
//  RichTextDataReaderTests.swift
//  OribiRichTextKitTests
//
//  Created by Daniel Saidi on 2022-01-25.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class RichTextDataReaderTests: XCTestCase {
    
    func dataForFormatCanGenerateArchivedData() {
        let string = NSAttributedString(string: "foo")
        guard let data = try? string.data(for: .archivedData) else {
            return XCTFail("Could not generate file wrapper data")
        }
        let result = RichTextDataFormat.parse(data)
        XCTAssertEqual(result.format, .archivedData)
        XCTAssertEqual(result.text.string, "foo")
    }

    func dataForFormatCanGeneratePlainTextData() {
        let string = NSAttributedString(string: "foo")
        guard let data = try? string.data(for: .plainText) else {
            return XCTFail("Could not generate file wrapper data")
        }
        let result = RichTextDataFormat.parse(data)
        XCTAssertEqual(result.format, .rtf)
        XCTAssertEqual(result.text.string, "foo")
    }

    func dataForFormatCanGenerateRtfData() {
        let string = NSAttributedString(string: "foo")
        guard let data = try? string.data(for: .rtf) else {
            return XCTFail("Could not generate file wrapper data")
        }
        let result = RichTextDataFormat.parse(data)
        XCTAssertEqual(result.format, .rtf)
        XCTAssertEqual(result.text.string, "foo")
    }
}
