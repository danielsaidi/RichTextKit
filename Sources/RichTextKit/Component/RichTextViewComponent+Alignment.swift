//
//  RichTextViewComponent+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {
    
    /// Get the text alignment.
    var richTextAlignment: RichTextAlignment? {
        guard let style = richTextParagraphStyle else { return nil }
        return RichTextAlignment(style.alignment)
    }
    
    /// Set the text alignment.
    ///
    /// > Important: This function will affect the next line
    /// if it changes the `richTextParagraphStyle` value, so
    /// it instead creates a brand new paragraph style.
    func setRichTextAlignment(_ alignment: RichTextAlignment) {
        if richTextAlignment == alignment { return }
        guard let storage = textStorageWrapper else { return }
        let range = lineRange(for: selectedRange)
        guard range.length > 0 else { return }
        let style = NSMutableParagraphStyle(alignment: alignment)
        storage.addAttribute(.paragraphStyle, value: style, range: range)
    }
}
