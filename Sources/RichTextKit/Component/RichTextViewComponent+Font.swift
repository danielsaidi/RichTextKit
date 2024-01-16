//
//  RichTextViewComponent+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

public extension RichTextViewComponent {

    /// Get the current rich text font.
    var richTextFont: FontRepresentable? {
        richTextAttributes[.font] as? FontRepresentable ?? typingAttributes[.font] as? FontRepresentable
    }

    /// Get the current rich text font size.
    var richTextFontSize: CGFloat? {
        richTextFont?.pointSize
    }

    /// Get the current rich text font name.
    var richTextFontName: String? {
        richTextFont?.fontName
    }

    /// Set the current rich text font.
    func setRichTextFont(_ font: FontRepresentable) {
        setRichTextAttribute(.font, to: font)
    }

    /// Set the current rich text font name.
    func setRichTextFontName(_ name: String) {
        if richTextFontName == name { return }
        if hasSelectedRange {
            setRichTextFontName(name, at: selectedRange)
        } else {
            setFontNameAtCurrentPosition(to: name)
        }
    }

    /// Set the current rich text font size.
    func setRichTextFontSize(_ size: CGFloat) {
        if size == richTextFontSize { return }
        #if macOS
        setRichTextFontSize(size, at: selectedRange)
        setFontSizeAtCurrentPosition(size)
        #else
        if hasSelectedRange {
            setRichTextFontSize(size, at: selectedRange)
        } else {
            setFontSizeAtCurrentPosition(size)
        }
        #endif
    }

    /// Step the current rich text font size up or down.
    func stepRichTextFontSize(points: Int) {
        let currentSize = richTextFontSize ?? .standardRichTextFontSize
        let newSize = currentSize + CGFloat(points)
        setRichTextFontSize(newSize)
    }
}

private extension RichTextViewComponent {

    /**
     Set the font at the current position.

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
     */
    func setFontNameAtCurrentPosition(to name: String) {
        var attributes = typingAttributes
        let oldFont = attributes[.font] as? FontRepresentable ?? .standardRichTextFont
        let size = oldFont.pointSize
        let newFont = FontRepresentable(name: name, size: size)
        attributes[.font] = newFont
        typingAttributes = attributes
    }

    /**
     Set the font size at the current position.

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
     */
    func setFontSizeAtCurrentPosition(_ size: CGFloat) {
        var attributes = typingAttributes
        let oldFont = attributes[.font] as? FontRepresentable ?? .standardRichTextFont
        let newFont = oldFont.withSize(size)
        attributes[.font] = newFont
        typingAttributes = attributes
    }
}
