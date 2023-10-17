//
//  RichTextAttributeWriter+Indent.swift
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

public extension RichTextAttributeWriter {

    /**
     Set the rich text indent at the provided range.

     Unlike some other attributes, the indent is not only
     used by the provided range, but the entire paragraph. A
     change must therefore be applied to an entire paragraph,
     which makes the code a bit more complicated. The result
     is highly a result of trial and error.

     - Parameters:
       - points: The indent to set.
       - range: The range for which to set the indent.
     */
    func stepRichTextIndent(
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
            return stepRichTextIndent(points: points, atIndex: 0)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return stepRichTextIndent(points: points, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return stepRichTextIndent(points: points, atIndex: index)
    }
    
    /**
     Step the text indent at a certain index.
     
     - Parameters:
       - points: The number of points to step.
       - index: The index to affect.
     */
    func stepRichTextIndent(
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

    /**
     Step the text indent at a certain index.
     
     - Parameters:
       - points: The number of points to step.
       - index: The index to affect.
     */
    func stepRichTextIndent(
        points: CGFloat,
        atIndex index: UInt
    ) -> RichTextAttributes? {
        stepRichTextIndent(
            points: points,
            atIndex: Int(index)
        )
    }
}

extension RichTextAttributeWriter {

    /**
     Step the text indent at a certain range.
     
     - Parameters:
       - points: The number of points to step.
       - range: The range to affect.
     */
    func stepIndentInternal(
        points: CGFloat,
        at range: NSRange
    ) -> RichTextAttributes? {
        let text = richText.string
        _ = range.length
        let location = range.location
        let ulocation = UInt(location)
        let index = text.findIndexOfCurrentParagraph(from: ulocation)
        return stepRichTextIndent(
            points: points,
            atIndex: index
        )
    }
}
