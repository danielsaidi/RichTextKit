//
//  RichTextViewRepresentable+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

public extension RichTextViewRepresentable {

    /**
     Use the selected range (if any) or text position to get
     the current font.
     */
    var currentFont: FontRepresentable? {
        currentRichTextAttributes[.font] as? FontRepresentable
    }

    /**
     Use the selected range (if any) or text position to get
     the current font size.
     */
    var currentFontSize: CGFloat? {
        currentFont?.pointSize
    }

    /**
     Use the selected range (if any) or text position to get
     the current font name.
     */
    var currentFontName: String? {
        currentFont?.fontName
    }

    /**
     Use the selected range (if any) or text position to set
     the current font.
     */
    func setCurrentFont(to font: FontRepresentable) {
        setCurrentRichTextAttribute(.font, to: font)
    }

    /**
     Use the selected range (if any) or text position to set
     the current font name.
     */
    func setCurrentFont(named name: String) {
        if hasSelectedRange {
            setFont(named: name, at: selectedRange)
        } else {
            setFontAtCurrentPosition(named: name)
        }
    }

    /**
     Use the selected range (if any) or text position to set
     the current font size.
     */
    func setCurrentFontSize(_ size: CGFloat) {
        #if os(macOS)
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
}

private extension RichTextViewRepresentable {

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
    func setFontAtCurrentPosition(named name: String) {
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
