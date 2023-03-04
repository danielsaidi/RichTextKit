//
//  RichTextTabWriter.swift
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
 text tab writing functionality.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other types in the library.
 */
public protocol RichTextTabWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextTabWriter {}

public extension RichTextTabWriter {

    /**
     Set the rich text tab at the provided range.

     Unlike some other attributes, the tab is not only
     used by the provided range, but the entire paragraph. A
     change must therefore be applied to an entire paragraph,
     which makes the code a bit more complicated. The result
     is highly a result of trial and error.

     - Parameters:
       - tab: The tab to set.
       - range: The range for which to set the tab.
     */
    func setRichTextTab(
        to tab: RichTextTab,
        at range: NSRange
    ) {
        let text = richText.string

        // Text view has selected text
        if range.length > 0 {
            return setRichTextTab(tab, at: range)
        }

        // The cursor is at the beginning of the text
        if range.location == 0 {
            return setRichTextTab(tab, atIndex: 0)
        }

        // The cursor is immediately after a newline
        if let char = text.character(at: range.location - 1), char.isNewLineSeparator {
            return setRichTextTab(tab, atIndex: range.location)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return setRichTextTab(tab, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return setRichTextTab(tab, atIndex: index)
    }
}

private extension RichTextTabWriter {

    /**
     Set the rich text tab at the provided range.

     - Parameters:
       - tab: The tab to set.
       - range: The range for which to set the tab.
     */
    func setRichTextTab(
        _ tab: RichTextTab,
        at range: NSRange
    ) {
        let text = richText.string
        let length = range.length
        let location = range.location
        let ulocation = UInt(location)
        var index = text.findIndexOfCurrentParagraph(from: ulocation)
        setRichTextTab(tab, atIndex: index)
        repeat {
            let newIndex = text.findIndexOfNextParagraph(from: index)
            if newIndex > index && newIndex < (location + length) {
                setRichTextTab(tab, atIndex: newIndex)
            } else {
                break
            }
            index = newIndex
        } while true
    }

    /**
     Set the rich text tab at the provided index.

     - Parameters:
       - tab: The tab to set.
       - index: The text index for which to set the tab.
     */
    func setRichTextTab(
        _ tab: RichTextTab,
        atIndex index: Int
    ) {
        guard let text = mutableRichText else { return }
        let range = NSRange(location: index, length: 1)
        let safeRange = safeRange(for: range)
        var attributes = text.attributes(at: safeRange.location, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.tabStops = tab.nativeTab
        attributes[.paragraphStyle] = style
        text.beginEditing()
        text.setAttributes(attributes, range: safeRange)
        text.fixAttributes(in: safeRange)
        text.endEditing()
    }

    /**
     Set the text tab at the provided `index`.

     - Parameters:
       - tab: The tab to set.
       - index: The text index for which to set the tab.
     */
    func setRichTextTab(
        _ tab: RichTextTab,
        atIndex index: UInt
    ) {
        let index = Int(index)
        setRichTextTab(tab, atIndex: index)
    }
}
