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

    /// Get the current font.
    var currentFont: FontRepresentable? {
        currentRichTextAttributes[.font] as? FontRepresentable
    }

    /// Get the current font size.
    var currentFontSize: CGFloat? {
        currentFont?.pointSize
    }

    /// Get the current font name.
    var currentFontName: String? {
        currentFont?.fontName
    }

    /// Set the current font.
    func setCurrentFont(_ font: FontRepresentable) {
        setCurrentRichTextAttribute(.font, to: font)
    }

    /// Set the current font name.
    func setCurrentFontName(_ name: String) {
        if currentFontName == name { return }
        if hasSelectedRange {
            setRichTextFontName(name, at: selectedRange)
        } else {
            setFontNameAtCurrentPosition(to: name)
        }
    }

    /// Set the current font size.
    func setCurrentFontSize(_ size: CGFloat) {
        if size == currentFontSize { return }
        #if os(macOS)
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

    /// Step the current font size up or down.
    func stepCurrentFontSize(points: Int) {
        let currentSize = currentFontSize ?? .standardRichTextFontSize
        let newSize = currentSize + CGFloat(points)
        setCurrentFontSize(newSize)
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
