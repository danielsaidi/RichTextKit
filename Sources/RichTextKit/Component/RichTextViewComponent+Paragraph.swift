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
        guard let storage = textStorageWrapper else { return }
        let range = lineRange(for: selectedRange)
        guard range.length > 0 else { return }
        storage.addAttribute(.paragraphStyle, value: style, range: range)
    }
}
