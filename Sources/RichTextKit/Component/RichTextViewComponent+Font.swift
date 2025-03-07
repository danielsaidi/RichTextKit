//
//  RichTextViewComponent+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

/// These functions may seem complicated, but it is the only
/// way that seems to work correctly, so far.
///
/// I previously grabbed the `typingAttributes` and took the
/// `.font` attribute from it, then took its `fontDescriptor`
/// and created a new font with `withFamily`, then created a
/// new font with the new descriptor and old size.
///
/// That approach however fails since the San Francisco font
/// specifies a certain usage, that casuses the font name to
/// not apply. This code just creates a new font instead, so
/// be aware if something doesn't work as expected.
///
/// After removing the ``RichTextAttributeWriter`` in 1.0 we
/// can hopefully iterate more consistently on the extension.

import CoreGraphics
import Foundation

public extension RichTextViewComponent {

    /// Get the rich text font at current range.
    var richTextFont: FontRepresentable? {
        richTextAttributes[.font] as? FontRepresentable ?? typingAttributes[.font] as? FontRepresentable
    }

    /// Set the rich text font at current range.
    func setRichTextFont(_ font: FontRepresentable) {
        setRichTextAttribute(.font, to: font)
    }

    /// Set the rich text font name at current range.
    func setRichTextFontName(_ name: String) {
        if richTextFont?.fontName == name { return }
        FontRepresentable.selectedFontName = name
        if hasSelectedRange {
            setFontName(name, at: selectedRange)
        } else {
            setFontNameAtCurrentPosition(to: name)
        }
    }

    /// Set the rich text font size at current range.
    func setRichTextFontSize(_ size: CGFloat) {
        if size == richTextFont?.pointSize { return }
        #if macOS
        setFontSize(size, at: selectedRange)
        setFontSizeAtCurrentPosition(size)
        #else
        if hasSelectedRange {
            setFontSize(size, at: selectedRange)
        } else {
            setFontSizeAtCurrentPosition(size)
        }
        #endif
    }

    /// Step the rich text font size at current range.
    func stepRichTextFontSize(points: Int) {
        let old = richTextFont?.pointSize ?? .standardRichTextFontSize
        let new = max(0, old + CGFloat(points))
        setRichTextFontSize(new)
    }
}

private extension RichTextViewComponent {

    /// Set the font at the current position.
    func setFontNameAtCurrentPosition(to name: String) {
        var attributes = typingAttributes
        let oldFont = attributes[.font] as? FontRepresentable ?? .standardRichTextFont
        let size = oldFont.pointSize
        let newFont = FontRepresentable(name: name, size: size)
        attributes[.font] = newFont
        typingAttributes = attributes
    }

    /// Set the font size at the current position.
    func setFontSizeAtCurrentPosition(_ size: CGFloat) {
        var attributes = typingAttributes
        let oldFont = attributes[.font] as? FontRepresentable ?? .standardRichTextFont
        let newFont = oldFont.withSize(size)
        attributes[.font] = newFont
        typingAttributes = attributes
    }

    

    /// Set the font name at a certain range.
    func setFontName(_ name: String, at range: NSRange) {
        guard let text = mutableRichText else { return }
        guard text.length > 0 else { return }
        let fontName = settableFontName(for: name)
        text.beginEditing()
        text.enumerateAttribute(.font, in: range, options: .init()) { value, range, _ in
            let oldFont = value as? FontRepresentable ?? .standardRichTextFont
            let size = oldFont.pointSize
            let newFont = FontRepresentable(name: fontName, size: size) ?? .standardRichTextFont
            text.removeAttribute(.font, range: range)
            text.addAttribute(.font, value: newFont, range: range)
            text.fixAttributes(in: range)
        }
        text.endEditing()
    }

    func updateFontName(to fontName: String)  {
        guard let text = mutableRichText else { return }
        text.enumerateAttribute(.font, in: NSRange(location: 0, length: text.length), options: []) { value, range, _ in
            let oldFont = value as? FontRepresentable ?? .standardRichTextFont

            if let newFont = FontRepresentable(name: fontName, size: oldFont.pointSize) {
                text.removeAttribute(.font, range: range)
                text.addAttribute(.font, value: newFont, range: range)
                text.fixAttributes(in: range)
            }
        }
        text.endEditing()
    }

    /// Set the font size at a certain range.
    func setFontSize(_ size: CGFloat, at range: NSRange) {
        guard let text = mutableRichText else { return }
        guard text.length > 0 else { return }
        text.beginEditing()
        text.enumerateAttribute(.font, in: range, options: .init()) { value, range, _ in
            let oldFont = value as? FontRepresentable ?? .standardRichTextFont
            let newFont = oldFont.withSize(size)
            text.removeAttribute(.font, range: range)
            text.addAttribute(.font, value: newFont, range: range)
            text.fixAttributes(in: range)
        }
        text.endEditing()
    }
}

private extension RichTextAttributeWriter {

    /// We must adjust empty font names on some platforms.
    func settableFontName(for fontName: String) -> String {
        #if macOS
        fontName
        #else
        fontName
        #endif
    }
}
