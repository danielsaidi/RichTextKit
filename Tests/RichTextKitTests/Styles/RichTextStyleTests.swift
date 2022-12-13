//
//  RichTextStyleTests.swift
//  RichTextKitTests
//
//  Created by Daniel Saidi on 2021-12-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI
import XCTest

class RichTextStyleTests: XCTestCase {

    func icon(for style: RichTextStyle) -> Image {
        style.icon
    }

    func testIconIsValidForAllCases() {
        XCTAssertEqual(icon(for: .bold), .richTextStyleBold)
        XCTAssertEqual(icon(for: .italic), .richTextStyleItalic)
        XCTAssertEqual(icon(for: .underlined), .richTextStyleUnderline)
    }


    #if canImport(UIKit)
    func traits(for style: RichTextStyle) -> UIFontDescriptor.SymbolicTraits? {
        style.symbolicTraits
    }

    func testSymbolicTraitsAreValidForAllCases() {
        XCTAssertEqual(traits(for: .bold), .traitBold)
        XCTAssertEqual(traits(for: .italic), .traitItalic)
        XCTAssertNil(traits(for: .underlined))
    }
    #elseif os(macOS)
    func traits(for style: RichTextStyle) -> NSFontDescriptor.SymbolicTraits? {
        style.symbolicTraits
    }

    func testSymbolicTraitsAreValidForAllCases() {
        XCTAssertEqual(traits(for: .bold), .bold)
        XCTAssertEqual(traits(for: .italic), .italic)
        XCTAssertNil(traits(for: .underlined))
    }
    #endif
}
