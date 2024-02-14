//
//  RichTextAttributeWriter+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextAttributeWriter {

    /// Set the rich text alignment at a certain range.
    ///
    /// > Todo: Something's currently off with alignment. It
    /// spils over to other paragraphs when moving the input
    /// cursor and inserting new text.
    func setRichTextAlignment(
        _ alignment: RichTextAlignment,
        at range: NSRange
    ) {
        let text = richText.string
        let length = range.length
        let location = range.location
        let ulocation = UInt(location)
        let uindex = text.findIndexOfCurrentParagraph(from: ulocation)
        let index = Int(uindex)
        let diff = location - index
        let newLength = max(length + diff, 1)
        let newRange = NSRange(location: index, length: newLength)
        let alignment = alignment.nativeAlignment
        let safeRange = safeRange(for: newRange)
        #if os(macOS)
        mutableRichText?.setAlignment(alignment, range: safeRange)
        #else
        let paragraph = richTextParagraphStyle(at: safeRange) ?? .init()
        paragraph.alignment = alignment
        setRichTextAttribute(
            .paragraphStyle,
            to: paragraph,
            at: safeRange
        )
        #endif
    }
}
