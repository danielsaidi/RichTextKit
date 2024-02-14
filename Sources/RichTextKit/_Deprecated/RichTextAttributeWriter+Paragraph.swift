//
//  RichTextAttributeWriter+Paragraph.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-14.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

@available(*, deprecated, message: "Use RichTextViewComponent instead.")
public extension RichTextAttributeWriter {

    /// Set the rich text paragraph style at a certain range.
    func setRichTextParagraphStyle(
        to style: NSParagraphStyle,
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
        let safeRange = safeRange(for: newRange)
        setRichTextAttribute(.paragraphStyle, to: style, at: safeRange)
    }
}
