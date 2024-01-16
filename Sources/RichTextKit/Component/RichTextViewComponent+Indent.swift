//
//  RichTextViewComponent+Indent.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the current rich text indent.
    var richTextIndent: CGFloat? {
        let attribute: NSMutableParagraphStyle? = richTextAttribute(.paragraphStyle)
        guard let style = attribute else { return nil }
        return style.headIndent
    }

    /// Step the current rich text indent.
    func stepRichTextIndent(
        points: CGFloat
    ) {
        if !hasTrimmedText { return step(points: points) }
        let previousCharacter = richText.string.character(at: selectedRange.location - 1)
        let isNewLine = previousCharacter?.isNewLineSeparator ?? false
        if isNewLine { return step(points: points) }
        typingAttributes = stepRichTextIndent(points: points, at: selectedRange) ?? typingAttributes
    }
}

private extension RichTextViewComponent {

    /// Step the text indent at the current position.
    func step(points: CGFloat) {
        guard let style = typingAttributes[.paragraphStyle] as? NSParagraphStyle else { return }
        guard let mutableStyle = style.mutableCopy() as? NSMutableParagraphStyle else { return }

        let indentation = max(points, 0)
        mutableStyle.firstLineHeadIndent = indentation
        mutableStyle.headIndent = indentation

        var attributes = richTextAttributes
        attributes[.paragraphStyle] = mutableStyle
        typingAttributes = attributes
    }
}
