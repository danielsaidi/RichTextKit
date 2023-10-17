//
//  RichTextAttributeWriter+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeWriter {

    /// Set the font at a certain range.
    func setRichTextFont(
        _ font: FontRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.font, to: font, at: range)
    }
    
    /**
     Set the font name at a certain range.

     This function may seem complicated, but so far it's the
     only way setting the font name seems to work correctly.

     I previously grabbed the `typingAttributes` and grabbed
     the `[.font]` attribute from that dictionary, then took
     its `fontDescriptor` and created the new font using the
     `withFamily` function, then created a new font with the
     new descriptor and the old font point size. However, it
     fails, since the San Francisco font specifies a certain
     usage that causes the font name to not apply. This code
     just creates a new font, but be aware of this change if
     something turns out not to work as expected.

     - Parameters:
       - name: The name of the font to apply.
       - range: The range to affect, by default the entire text.
     */
    func setRichTextFontName(
        _ name: String,
        at range: NSRange? = nil
    ) {
        guard let text = mutableRichText else { return }
        guard text.length > 0 else { return }
        let range = range ?? richTextRange
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

    /// Set the font size at a certain range.
    func setRichTextFontSize(
        _ size: CGFloat,
        at range: NSRange? = nil
    ) {
        guard let text = mutableRichText else { return }
        guard text.length > 0 else { return }
        let range = range ?? richTextRange
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

    /// Step the font size at a certain range.
    func stepRichTextFontSize(
        points: Int,
        at range: NSRange
    ) {
        guard let size = richTextFontSize(at: range) else { return }
        let newSize = size + CGFloat(points)
        setRichTextFontSize(newSize, at: range)
    }
}

private extension RichTextAttributeWriter {

    /// We must adjust empty font names on some platforms.
    func settableFontName(for fontName: String) -> String {
        #if os(macOS)
        fontName.isEmpty ? "Helvetica" : fontName
        #else
        fontName
        #endif
    }
}
