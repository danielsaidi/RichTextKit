//
//  RichTextIndentWriter.swift
//  RichTextKit
//
//  Created by James Bradley on 2022-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/**
 This protocol extends ``RichTextAttributeWriter`` with rich
 text indent writing functionality.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other types in the library.
 */
public protocol RichTextIndentWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextIndentWriter {}

public extension RichTextIndentWriter {

    /**
     Set the rich text indent at the provided range.

     Unlike some other attributes, the indent is not only
     used by the provided range, but the entire paragraph. A
     change must therefore be applied to an entire paragraph,
     which makes the code a bit more complicated. The result
     is highly a result of trial and error.

     - Parameters:
       - indent: The indent to set.
       - range: The range for which to set the indent.
     */
    func setRichTextIndent(
        to indent: RichTextIndent,
        at range: NSRange
    ) {
        let text = richText.string

        // Text view has selected text
        if range.length > 0 {
            return setRichTextIndent(indent, at: range)
        }

        // The cursor is at the beginning of the text
        if range.location == 0 {
            return setRichTextIndent(indent, atIndex: 0)
        }

        // The cursor is immediately after a newline
        if let char = text.character(at: range.location - 1), char.isNewLineSeparator {
            return setRichTextIndent(indent, atIndex: range.location)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return setRichTextIndent(indent, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return setRichTextIndent(indent, atIndex: index)
    }
}

private extension RichTextIndentWriter {

    /**
     Set the rich text indent at the provided range.

     - Parameters:
       - indent: The indent to set.
       - range: The range for which to set the indent.
     */
    func setRichTextIndent(
        _ indent: RichTextIndent,
        at range: NSRange
    ) {
        let text = richText.string
        let length = range.length
        let location = range.location
        let ulocation = UInt(location)
        var index = text.findIndexOfCurrentParagraph(from: ulocation)
        setRichTextIndent(indent, atIndex: index)
//        repeat {
//            let newIndex = text.findIndexOfNextParagraph(from: index)
//            if newIndex > index && newIndex < (location + length) {
//                setRichTextIndent(indent, atIndex: newIndex)
//            } else {
//                break
//            }
//            index = newIndex
//        } while true
    }

    /**
     Set the rich text indent at the provided index.

     - Parameters:
       - indent: The indent to set.
       - index: The text index for which to set the indent.
     */
    func setRichTextIndent(
        _ indent: RichTextIndent,
        atIndex index: Int
    ) {
        guard let text = mutableRichText else { return }
        let range = NSRange(location: index, length: 1)
        let safeRange = safeRange(for: range)
        var attributes = text.attributes(at: safeRange.location, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        
        let indentation = max(indent == .decrease ? style.headIndent - 30.0 : style.headIndent + 30.0, 0)
        style.firstLineHeadIndent = indentation
        style.headIndent = indentation
        
        attributes[.paragraphStyle] = style
        text.beginEditing()
        text.setAttributes(attributes, range: safeRange)
        text.fixAttributes(in: safeRange)
        text.endEditing()
    }

    /**
     Set the text indent at the provided `index`.

     - Parameters:
       - indent: The indent to set.
       - index: The text index for which to set the indent.
     */
    func setRichTextIndent(
        _ indent: RichTextIndent,
        atIndex index: UInt
    ) {
        let index = Int(index)
        setRichTextIndent(indent, atIndex: index)
    }
}
