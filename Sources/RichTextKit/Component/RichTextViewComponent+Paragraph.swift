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
    var richTextParagraphStyle: NSMutableParagraphStyle? {
        richTextAttribute(.paragraphStyle)
    }

    /// Set the paragraph style.
    ///
    /// > Todo: The function currently can't handle multiple
    /// selected paragraphs. If many paragraphs are selected,
    /// it will only affect the first one.
    func setRichTextParagraphStyle(_ style: NSParagraphStyle) {
        let range = lineRange(for: selectedRange)
        if selectedRange.length > 0 {
            typingAttributes[.paragraphStyle] = style
        }
        #if os(watchOS)
        setRichTextAttribute(.paragraphStyle, to: style, at: range)
        #else
        textStorageWrapper?.addAttribute(.paragraphStyle, value: style, range: range)
        #endif
    }

    func registerUndo() {
        let range = selectedRange
        guard range.length > 0 else { return }
        let textView = self as? RichTextView
        #if canImport(UIKit)
        let undoManager = textView?.undoManager
        #elseif canImport(AppKit)
        let undoManager = textView?.undoManager
        #endif
        guard let undoManager = undoManager, let text = mutableRichText, let textView else {
            return
        }
        // Store the previous paragraph style
        let currentAttributes = NSAttributedString(attributedString: text.attributedSubstring(from: range))

        undoManager.registerUndo(withTarget: textView) { target in
            target.mutableRichText?.replaceCharacters(in: range, with: currentAttributes)
        }
        undoManager.setActionName("Change Paragraph Style")


    }
}
