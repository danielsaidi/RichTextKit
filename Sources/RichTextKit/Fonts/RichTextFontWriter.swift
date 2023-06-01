//
//  RichTextFontWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

/**
 This protocol extends ``RichTextAttributeWriter`` with rich
 text font writing functionality.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other types in the library.
 */
public protocol RichTextFontWriter: RichTextAttributeReader, RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextFontWriter {}

public extension RichTextFontWriter {

    /**
     Set the font at a certain range.

     - Parameters:
       - range: The range to affect, by default the entire text.
     */
    func setFont(
        to font: FontRepresentable,
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
    func setFontName(
        to name: String,
        at range: NSRange? = nil
    ) {
        guard let text = mutableRichText else { return }
        guard text.length > 0 else { return }
        let range = range ?? richTextRange
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

    /**
     Set the font size at a certain range.

     This function will iterate over a the range and replace
     the old font with a copy where the size has changed.

     - Parameters:
       - size: The font size to set.
       - range: The range to affect, by default the entire text.
     */
    func setFontSize(
        to size: CGFloat,
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

    /**
     Increase or decrease the font size at a certain range.

     - Parameters:
       - points: The number of points to increase or decrease the font size.
       - range: The range affect.
     */
    func stepFontSize(
        points: Int,
        at range: NSRange
    ) {
        let attr: FontRepresentable? = richTextAttribute(.font, at: range)
        guard let font = attr else { return }
        let size = font.pointSize
        let newSize = size + CGFloat(points)
        setFontSize(to: newSize, at: range)
    }
}

public extension RichTextFontWriter {

    /**
     Decrement the font size 1 point at a certain range.

     - Parameters:
       - range: The range to affect.
     */
    func decrementFontSize(at range: NSRange) {
        decrementFontSize(points: 1, at: range)
    }

    /**
     Decrement the font size at a certain range.

     - Parameters:
       - points: The number of points to decrement the font size, by default `1`.
       - range: The range to affect.
     */
    func decrementFontSize(
        points: UInt,
        at range: NSRange
    ) {
        stepFontSize(points: -Int(points), at: range)
    }

    /**
     Increment the font size 1 point at a certain range.

     - Parameters:
       - range: The range to affect.
     */
    func incrementFontSize(at range: NSRange) {
        incrementFontSize(points: 1, at: range)
    }

    /**
     Increment the font size at a certain range.

     - Parameters:
       - points: The number of points to increment the font size, by default `1`.
       - range: The range to affect.
     */
    func incrementFontSize(
        points: UInt,
        at range: NSRange
    ) {
        stepFontSize(points: Int(points), at: range)
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
