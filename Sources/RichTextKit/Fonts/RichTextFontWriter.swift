//
//  RichTextFontWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 extended rich text font writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextFontWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextFontWriter {}

public extension RichTextFontWriter {

    /**
     Set the font at a certain `range`.

     - Parameters:
       - range: The range to get the font from.
     */
    func setFont(
        _ font: FontRepresentable,
        at range: NSRange
    ) {
        setRichTextAttribute(.font, to: font, at: range)
    }

    /**
     Set the font at a certain `range`.

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
       - range: The range to get the font from.
     */
    func setFont(
        named name: String,
        at range: NSRange
    ) {
        guard let text = mutableRichText else { return }
        guard text.length > 0 else { return }
        let key = NSAttributedString.Key.font
        let fontName = settableFontName(for: name)
        text.beginEditing()
        text.enumerateAttribute(key, in: range, options: .init()) { value, range, _ in
            let oldFont = value as? FontRepresentable ?? .standardRichTextFont
            let size = oldFont.pointSize
            let newFont = FontRepresentable(name: fontName, size: size) ?? .standardRichTextFont
            text.removeAttribute(key, range: range)
            text.addAttribute(key, value: newFont, range: range)
            text.fixAttributes(in: range)
        }
        text.endEditing()
    }
}

private extension RichTextFontWriter {

    /**
     We must adjust empty font names on some platforms since
     it may mess up the font size.
     */
    func settableFontName(for fontName: String) -> String {
        #if os(macOS)
        fontName.isEmpty ? "Helvetica" : fontName
        #else
        fontName
        #endif
    }
}
