//
//  RichTextAlignmentWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/**
 This protocol can be implemented any types that can provide
 rich text alignment writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextAlignmentWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextAlignmentWriter {}

public extension RichTextAlignmentWriter {

    /**
     Set the rich text alignment at the provided range.

     Unlike some other attributes, the alignment is not only
     used by the provided range, but the entire paragraph. A
     change must therefore be applied to an entire paragraph,
     which makes the code a bit more complicated. The result
     is highly a result of trial and error.

     - Parameters:
       - alignment: The alignment to set.
       - range: The range for which to set the alignment.
     */
    func setRichTextAlignment(
        to alignment: RichTextAlignment,
        at range: NSRange
    ) {
        let text = richText.string

        // Text view has selected text
        if range.length > 0 {
            return setRichTextAlignment(alignment, at: range)
        }

        // The cursor is at the beginning of the text
        if range.location == 0 {
            return setRichTextAlignment(alignment, atIndex: 0)
        }

        // The cursor is immediately after a newline
        if let char = text.character(at: range.location - 1), char.isNewLineSeparator {
            return setRichTextAlignment(alignment, atIndex: range.location)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return setRichTextAlignment(alignment, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return setRichTextAlignment(alignment, atIndex: index)
    }
}

private extension RichTextAlignmentWriter {

    /**
     Set the rich text alignment at the provided range.

     - Parameters:
       - alignment: The alignment to set.
       - range: The range for which to set the alignment.
     */
    func setRichTextAlignment(
        _ alignment: RichTextAlignment,
        at range: NSRange
    ) {
        let text = richText.string
        let length = range.length
        let location = range.location
        let ulocation = UInt(location)
        var index = text.findIndexOfCurrentParagraph(from: ulocation)
        setRichTextAlignment(alignment, atIndex: index)
        repeat {
            let newIndex = text.findIndexOfNextParagraph(from: index)
            if newIndex > index && newIndex < (location + length) {
                setRichTextAlignment(alignment, atIndex: newIndex)
            } else {
                break
            }
            index = newIndex
        } while true
    }

    /**
     Set the rich text alignment at the provided index.

     - Parameters:
       - alignment: The alignment to set.
       - index: The text index for which to set the alignment.
     */
    func setRichTextAlignment(
        _ alignment: RichTextAlignment,
        atIndex index: Int
    ) {
        guard let text = mutableRichText else { return }
        let range = NSRange(location: index, length: 1)
        let safeRange = safeRange(for: range)
        var attributes = text.attributes(at: safeRange.location, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.alignment = alignment.nativeAlignment
        attributes[.paragraphStyle] = style
        text.beginEditing()
        text.setAttributes(attributes, range: safeRange)
        text.fixAttributes(in: safeRange)
        text.endEditing()
    }

    /**
     Set the text alignment at the provided `index`.

     - Parameters:
       - alignment: The alignment to set.
       - index: The text index for which to set the alignment.
     */
    func setRichTextAlignment(
        _ alignment: RichTextAlignment,
        atIndex index: UInt
    ) {
        let index = Int(index)
        setRichTextAlignment(alignment, atIndex: index)
    }
}
