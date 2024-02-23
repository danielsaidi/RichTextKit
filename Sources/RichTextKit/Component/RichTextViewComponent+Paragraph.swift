//
//  RichTextViewComponent+Paragraph.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-17.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the paragraph style.
    /// We need to get paragraph style from text storage because attributed string
    /// doesn't inherit those attributes from storage. It simply doesnt mirror.
    /// Appears like a bug on Apples side.
    public var richTextParagraphStyle: NSMutableParagraphStyle? {
        textStorageWrapper?.richTextParagraphStyle(at: selectedRange)
    }

    /// Set the paragraph style.
    ///
    /// > Todo: The function currently can't handle multiple
    /// selected paragraphs. If many paragraphs are selected,
    /// it will only affect the first one.
    func setRichTextParagraphStyle(_ style: NSParagraphStyle) {
        let range: NSRange
        if multipleSelectedLines() {
            range = safeRange(for: selectedRange)
        } else {
            range = lineRange(for: selectedRange)
        }

        #if os(watchOS)
        setRichTextAttribute(.paragraphStyle, to: style, at: range)
        #else
        setRichTextAttribute(.paragraphStyle, to: style)
        textStorageWrapper?.addAttribute(.paragraphStyle, value: style, range: range)
        #endif
    }

    private func multipleSelectedLines() -> Bool {
        guard let selectedText = textStorageWrapper?.attributedSubstring(from: selectedRange) else { return false }
        let selectedLines = selectedText.string.components(separatedBy: .newlines)

        return selectedLines.count > 1
    }
}
