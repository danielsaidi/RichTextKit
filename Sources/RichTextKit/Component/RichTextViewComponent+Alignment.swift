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
        registerUndo()
        if richTextAlignment == alignment { return }
        let style = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            alignment: alignment
        )
        setRichTextParagraphStyle(style)
    }
}
