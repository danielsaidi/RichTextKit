//
//  RichTextViewComponent+Alignment.swift
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

public extension RichTextViewComponent {

    /// Get the rich text alignment at current range.
    var richTextAlignment: RichTextAlignment? {
        guard let style = richTextParagraphStyle else { return nil }
        return RichTextAlignment(style.alignment)
    }

    /// Set the rich text alignment at current range.
    ///
    /// > Todo: Something's currently off with alignment. It
    /// spils over to other paragraphs when moving the input
    /// cursor and inserting new text.
    func setRichTextAlignment(
        _ alignment: RichTextAlignment
    ) {
        if richTextAlignment == alignment { return }
        if !hasTrimmedText || !hasSelectedRange {
            let style = NSMutableParagraphStyle()
            style.alignment = alignment.nativeAlignment
            var attributes = richTextAttributes
            attributes[.paragraphStyle] = style
            typingAttributes = attributes
        } else {
            setRichTextAlignment(alignment, at: selectedRange)
        }
    }
}
