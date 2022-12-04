//
//  FontRepresentable+RichTextTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import XCTest

class FontRepresentable_RichTextTests: XCTestCase {
    
    func textStandardRichTextFont() {
        let expected = FontRepresentable.systemFont(ofSize: .standardRichTextFontSize)
        XCTAssertEqual(FontRepresentable.standardRichTextFont, expected)
        FontRepresentable.standardRichTextFont = .standardRichTextFont
    }
}
