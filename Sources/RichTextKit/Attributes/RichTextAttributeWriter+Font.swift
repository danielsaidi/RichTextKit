//
//  RichTextAttributeWriter+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeWriter {

    /// Set the rich text font at a certain range.
    func setRichTextFont(
        _ font: FontRepresentable,
        at range: NSRange
    ) {
        setRichTextAttribute(.font, to: font, at: range)
    }

    /// Set the rich text font name at a certain range.
    ///
    /// This may seem complicated, but so far it is the only
    /// way that seems to work correctly.
    ///
    /// I previously grabbed the `typingAttributes` and took
    /// the `.font` attribute from the dictionary, then took
    /// its `fontDescriptor` and created a new font with the
    /// `withFamily` function, then created a new font using
    /// the new descriptor and the old font point size.
    ///
    /// However, that approach fails since the San Francisco
    /// font specifies a certain usage, that causes the font
    /// name to not apply. This code just creates a new font,
    /// but be aware if something doesn't work as expected.
    func setRichTextFontName(
        _ name: String,
        at range: NSRange
    ) {
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

    /// Set the rich text font size at a certain range.
    func setRichTextFontSize(
        _ size: CGFloat,
        at range: NSRange
    ) {
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

    /// Step the rich text font size at a certain range.
    func stepRichTextFontSize(
        points: Int,
        at range: NSRange
    ) {
        guard let size = richTextFont(at: range)?.pointSize else { return }
        let newSize = size + CGFloat(points)
        setRichTextFontSize(newSize, at: range)
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
