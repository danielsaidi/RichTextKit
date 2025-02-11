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
    func setRichTextAlignment(_ alignment: RichTextAlignment) {
        // Only apply changes if explicitly requested and different from current
        if richTextAlignment == alignment { return }
        
        // Don't apply changes if no text is selected
        guard selectedRange.length > 0 else { return }
        
        registerUndo()
        let style = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            alignment: alignment
        )
        // Ensure paragraph spacing is maintained
        style.paragraphSpacing = 20
        style.paragraphSpacingBefore = 20
        setRichTextParagraphStyle(style)
    }
}
