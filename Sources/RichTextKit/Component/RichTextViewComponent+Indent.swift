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

    /// Get the rich text indent at current range.
    var richTextIndent: CGFloat? {
        richTextParagraphStyle?.headIndent
    }

    /// Set the rich text indent at current range.
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
