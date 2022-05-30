//
//  RichTextViewRepresentable+Alignment.swift
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

public extension RichTextViewRepresentable {

    /**
     Use the selected range (if any) or text position to get
     the current rich text alignment.
     */
    var currentRichTextAlignment: RichTextAlignment? {
        let attribute: NSMutableParagraphStyle? = currentRichTextAttribute(.paragraphStyle)
        guard let style = attribute else { return nil }
        return RichTextAlignment(style.alignment)
    }

    /**
     Use the selected range (if any) or text position to set
     the current rich text alignment.

     This function is highly a result of trial and error. It
     sets the text alignment in various ways, based on which
     parts of the text should be affected.

     - Parameters:
       - alignment: The alignment to set.
     */
    func setCurrentRichTextAlignment(
        to alignment: RichTextAlignment
    ) {
        let text = richText.string
        let selectedLength = selectedRange.length
        let selectedLocation = selectedRange.location

        // Text view has no text
        if !hasTrimmedText {
            return setTextAlignmentAtCurrentPosition(alignment)
        }

        // Text view has selected text
        if selectedLength > 0 {
            return setTextAlignmentForCurrentSelection(alignment)
        }

        // The cursor is at the beginning of the text
        if selectedLocation == 0 {
            return setTextAlignment(alignment, atIndex: 0)
        }

        // The cursor is at the end of the text
        if selectedLocation == text.count {
            return setTextAlignmentAtEnd(alignment)
        }

        // The cursor is immediately after a newline
        if let char = text.character(at: selectedLocation - 1), char.isNewLineSeparator {
            return setTextAlignment(alignment, atIndex: selectedLocation)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: selectedLocation), char.isNewLineSeparator {
            let location = UInt(selectedLocation)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return setTextAlignment(alignment, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(selectedLocation)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return setTextAlignment(alignment, atIndex: index)
    }
}

private extension RichTextViewRepresentable {

    /**
     Set the text alignment at the last character.
     */
    func setTextAlignmentAtEnd(_ alignment: RichTextAlignment) {
        let text = richText.string
        let endPosition = text.count - 1
        let char = text.character(at: endPosition) ?? Character("")
        if char == .newLine || char == .carriageReturn {
            return setTextAlignmentAtCurrentPosition(alignment)
        }
        let nextParagraph = text.findIndexOfNextParagraph(from: UInt(text.count))
        setTextAlignment(alignment, atIndex: nextParagraph)
    }

    /**
     Set the text alignment for the current selection.
     */
    func setTextAlignmentForCurrentSelection(_ alignment: RichTextAlignment) {
        let text = richText.string
        let length = selectedRange.length
        let location = selectedRange.location
        var index = text.findIndexOfCurrentParagraph(from: UInt(location))
        setTextAlignment(alignment, atIndex: index)
        repeat {
            let newIndex = text.findIndexOfNextParagraph(from: index)
            if newIndex > index && newIndex < (location + length) {
                setTextAlignment(alignment, atIndex: newIndex)
            } else {
                break
            }
            index = newIndex
        } while true
    }

    /**
     Set the text alignment at the provided `index`.
     */
    func setTextAlignment(_ alignment: RichTextAlignment, atIndex index: Int) {
        guard let string = mutableRichText else { return }
        let range = NSRange(location: index, length: 1)
        var attributes = attributedString.attributes(at: index, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.alignment = alignment.nativeAlignment
        attributes[.paragraphStyle] = style
        string.beginEditing()
        string.setAttributes(attributes, range: range)
        string.fixAttributes(in: range)
        string.endEditing()
    }

    /**
     Set the text alignment at the provided `index`.
     */
    func setTextAlignment(_ alignment: RichTextAlignment, atIndex index: UInt) {
        setTextAlignment(alignment, atIndex: Int(index))
    }

    /**
     Set the text alignment at the current position.
     */
    func setTextAlignmentAtCurrentPosition(_ alignment: RichTextAlignment) {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment.nativeAlignment
        var attributes = currentRichTextAttributes
        attributes[.paragraphStyle] = style
        typingAttributes = attributes
    }
}
