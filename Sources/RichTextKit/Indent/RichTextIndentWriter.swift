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
public protocol RichTextIndentWriter: RichTextAttributeWriter {
    func setRichTextIndent(to indent: RichTextIndent, at range: NSRange)
}

extension NSMutableAttributedString: RichTextIndentWriter {}

public extension RichTextIndentWriter {

    func setRichTextIndent(
        to indent: RichTextIndent,
        at range: NSRange
    ) {
        let text = mutableRichText?.string ?? ""

        // Text view has selected text
        if range.length > 0 {
            setRichTextIndent(indent, at: range)
        }

        // The cursor is at the beginning of the text
        if range.location == 0 {
            let length = text.findLengthOfCurrentParagraph(from: UInt(range.location))
            setRichTextIndent(indent, atIndex: 0, styleLength: length)
        }

        // The cursor is immediately after a newline
        if let char = text.character(at: range.location - 1), char.isNewLineSeparator {
            setRichTextIndent(indent, atIndex: range.location, styleLength: 1)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = Int(text.findIndexOfCurrentParagraph(from: location))
            let length = text.findLengthOfCurrentParagraph(from: location)
            setRichTextIndent(indent, atIndex: index, styleLength: length)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = Int(text.findIndexOfCurrentParagraph(from: location))
        let length = text.findLengthOfCurrentParagraph(from: location)
        setRichTextIndent(indent, atIndex: index, styleLength: length)
    }
}

private extension RichTextIndentWriter {

    func setRichTextIndent(
        _ indent: RichTextIndent,
        at range: NSRange
    ) {
        let text = mutableRichText?.string ?? ""
        let location = range.location
        let ulocation = UInt(location)
        let index = Int(text.findIndexOfCurrentParagraph(from: ulocation))
        let length = text.findLengthOfCurrentParagraph(from: ulocation)
        setRichTextIndent(indent, atIndex: index, styleLength: length)
    }

    func setRichTextIndent(
        _ indent: RichTextIndent,
        atIndex index: Int,
        styleLength length: Int
    ) {
        guard let text = mutableRichText else { return }
        let range = NSRange(location: index, length: length)
        let safeRange = safeRange(for: range)
        var attributes = text.attributes(at: safeRange.location, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()

        let indentAmount: CGFloat = 30.0
        let maxIndent: CGFloat = 300.0

        let currentIndent = style.headIndent
        var newIndent: CGFloat
        if indent == .decrease {
            newIndent = max(currentIndent - indentAmount, 0)
        } else {
            newIndent = min(currentIndent + indentAmount, maxIndent)
        }

        style.firstLineHeadIndent = newIndent
        style.headIndent = newIndent

        attributes[.paragraphStyle] = style
        text.beginEditing()
        text.setAttributes(attributes, range: safeRange)
        text.fixAttributes(in: safeRange)
        text.endEditing()
    }
}
