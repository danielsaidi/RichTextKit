//
//  RichTextViewComponent+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {
    
    /// Get the rich text alignment at current range.
    var richTextAlignment: RichTextAlignment? {
        guard let style = richTextParagraphStyle else { return nil }
        return RichTextAlignment(style.alignment)
    }
    
    /// Set the rich text alignment at current range.
    ///
    /// This function does not use ``RichTextAttributeWriter``
    /// since the text views require affecting text storage.
    ///
    /// > Important: This function will affect the next line
    /// of text if we grab `richTextParagraphStyle` and make
    /// the alignment change to it, instead of creating this
    /// brand new paragraph style.
    func setRichTextAlignment(
        _ alignment: RichTextAlignment
    ) {
        if richTextAlignment == alignment { return }
        guard let storage = textStorageWrapper else { return }
        let range = lineRange(for: selectedRange)
        guard range.length > 0 else { return }
        let style = NSMutableParagraphStyle(alignment)
        storage.addAttribute(.paragraphStyle, value: style, range: range)
    }
}

private extension NSMutableParagraphStyle {
    
    convenience init(_ alignment: RichTextAlignment) {
        self.init()
        self.alignment = alignment.nativeAlignment
    }
}
