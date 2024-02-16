//
//  RichTextViewComponent+Indent.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the rich text indent at current range.
    var richTextIndent: CGFloat? {
        richTextParagraphStyle?.headIndent
    }

    /// Set the rich text indent at current range.
    ///
    /// Unlike some other attributes, this attribute applies
    /// to the entire paragraph, not just the selected range.
    func stepRichTextIndent(
        points: CGFloat
    ) {
        if !hasTrimmedText { return stepIndent(points: points) }
        let previousCharacter = richText.string.character(at: selectedRange.location - 1)
        let isNewLine = previousCharacter?.isNewLineSeparator ?? false
        if isNewLine { return stepIndent(points: points) }
        typingAttributes = stepIndent(points: points, at: selectedRange) ?? typingAttributes
    }
}

private extension RichTextViewComponent {

    func stepIndent(
        points: CGFloat
    ) {
        guard let style = typingAttributes[.paragraphStyle] as? NSParagraphStyle else { return }
        guard let mutableStyle = style.mutableCopy() as? NSMutableParagraphStyle else { return }

        let indentation = max(points, 0)
        mutableStyle.firstLineHeadIndent = indentation
        mutableStyle.headIndent = indentation

        var attributes = richTextAttributes
        attributes[.paragraphStyle] = mutableStyle
        typingAttributes = attributes
    }

    /// Set the rich text indent at a certain range.
    func stepIndent(
        points: CGFloat,
        at range: NSRange
    ) -> RichTextAttributes? {
        let text = richText.string

        // Text view has selected text
        if range.length > 0 {
            return stepIndentInternal(points: points, at: range)
        }

        // The cursor is at the beginning of the text
        if range.location == 0 {
            return stepIndent(points: points, atIndex: 0)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return stepIndent(points: points, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return stepIndent(points: points, atIndex: index)
    }
}

private extension RichTextAttributeWriter {

    /// Step the rich text indent at a certain index.
    func stepIndent(
        points: CGFloat,
        atIndex index: Int
    ) -> RichTextAttributes? {
        guard let text = mutableRichText else { return nil }
        let range = NSRange(location: index, length: 1)
        let safeRange = safeRange(for: range, isAttributeOperation: true)
        var attributes = text.attributes(at: safeRange.location, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()

        let newIndent = max(style.headIndent + points, 0)
        style.firstLineHeadIndent = newIndent
        style.headIndent = newIndent

        attributes[.paragraphStyle] = style
        text.beginEditing()
        text.setAttributes(attributes, range: safeRange)
        text.fixAttributes(in: safeRange)
        text.endEditing()

        return attributes
    }

    /// Step the rich text indent at a certain index.
    func stepIndent(
        points: CGFloat,
        atIndex index: UInt
    ) -> RichTextAttributes? {
        stepIndent(
            points: points,
            atIndex: Int(index)
        )
    }

    /// Step the text indent at a certain range.
    func stepIndentInternal(
        points: CGFloat,
        at range: NSRange
    ) -> RichTextAttributes? {
        let text = richText.string
        _ = range.length
        let location = range.location
        let ulocation = UInt(location)
        let index = text.findIndexOfCurrentParagraph(from: ulocation)
        return stepIndent(
            points: points,
            atIndex: index
        )
    }
}
