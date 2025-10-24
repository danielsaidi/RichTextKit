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

    /// Get the current paragraph style.
    var richTextParagraphStyle: NSMutableParagraphStyle? {
        richTextAttribute(.paragraphStyle)
    }

    /// Get a certain value from the current paragraph style.
    func richTextParagraphStyleValue<ValueType>(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>
    ) -> ValueType? {
        richTextParagraphStyle?[keyPath: keyPath]
    }

    /// Set the current paragraph style.
    ///
    /// > Todo: The function currently can't handle multiple selected paragraphs.
    /// If many paragraphs are selected, it will only affect the first one.
    func setRichTextParagraphStyle(_ style: NSParagraphStyle) {
        let range = lineRange(for: selectedRange)
        guard range.length > 0 else { return }
        #if os(watchOS)
        setRichTextAttribute(.paragraphStyle, to: style, at: range)
        #else
        textStorageWrapper?.addAttribute(.paragraphStyle, value: style, range: range)
        #endif
    }

    /// Set a certain value for the current paragraph style.
    func setRichTextParagraphStyleValue<ValueType>(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>,
        _ value: ValueType
    ) {
        var style = richTextParagraphStyle ?? .init()
        style[keyPath: keyPath] = value
        setRichTextParagraphStyle(style)
    }

    /// Step a certain value for the current paragraph style.
    func stepRichTextParagraphStyleValue(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, Int>,
        _ change: Int
    ) {
        let current = richTextParagraphStyleValue(keyPath) ?? 0
        setRichTextParagraphStyleValue(keyPath, current + change)
    }

    /// Step a certain value for the current paragraph style.
    func stepRichTextParagraphStyleValue(
        _ keyPath: WritableKeyPath<NSMutableParagraphStyle, CGFloat>,
        _ change: CGFloat
    ) {
        let current = richTextParagraphStyleValue(keyPath) ?? 0
        setRichTextParagraphStyleValue(keyPath, current + change)
    }
}
