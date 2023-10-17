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

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextAttributeWriter {

    /**
     Set the text alignment at a certain range.

     Unlike some other attributes, this value applies to the
     entire paragraph, not just the selected range.
     */
    func setRichTextAlignment(
        _ alignment: RichTextAlignment,
        at range: NSRange
    ) {
        let text = richText.string

        // Text view has selected text
        if range.length > 0 {
            return setAlignment(alignment, at: range)
        }

        // The cursor is at the beginning of the text
        if range.location == 0 {
            return setAlignment(alignment, atIndex: 0)
        }

        // The cursor is immediately after a newline
        if let char = text.character(at: range.location - 1), char.isNewLineSeparator {
            return setAlignment(alignment, atIndex: range.location)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return setAlignment(alignment, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return setAlignment(alignment, atIndex: index)
    }
}

private extension RichTextAttributeWriter {

    func setAlignment(
        _ alignment: RichTextAlignment,
        at range: NSRange
    ) {
        let text = richText.string
        let length = range.length
        let location = range.location
        let ulocation = UInt(location)
        var index = text.findIndexOfCurrentParagraph(from: ulocation)
        setAlignment(alignment, atIndex: index)
        repeat {
            let newIndex = text.findIndexOfNextParagraph(from: index)
            if newIndex > index && newIndex < (location + length) {
                setAlignment(alignment, atIndex: newIndex)
            } else {
                break
            }
            index = newIndex
        } while true
    }

    func setAlignment(
        _ alignment: RichTextAlignment,
        atIndex index: Int
    ) {
        guard let text = mutableRichText else { return }
        let range = NSRange(location: index, length: 1)
        let safeRange = safeRange(for: range, isAttributeOperation: true)
        var attributes = text.attributes(at: safeRange.location, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.alignment = alignment.nativeAlignment
        attributes[.paragraphStyle] = style
        text.beginEditing()
        text.setAttributes(attributes, range: safeRange)
        text.fixAttributes(in: safeRange)
        text.endEditing()
    }

    func setAlignment(
        _ alignment: RichTextAlignment,
        atIndex index: UInt
    ) {
        let index = Int(index)
        setAlignment(alignment, atIndex: index)
    }
}
