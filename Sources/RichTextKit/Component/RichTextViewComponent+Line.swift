//
//  RichTextViewComponent+Line.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the line spacing.
    var richTextLineSpacing: CGFloat? {
        richTextParagraphStyle?.lineSpacing
    }

    /// Set the line spacing.
    ///
    /// > Todo: The function currently can't handle multiple
    /// selected paragraphs. If many paragraphs are selected,
    /// it will only affect the first one. 
    func setRichTextLineSpacing(_ spacing: CGFloat) {
        if richTextLineSpacing == spacing { return }
        let style = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            lineSpacing: spacing
        )
        setRichTextParagraphStyle(style)
    }

    /// Step the line spacing.
    func stepRichTextLineSpacing(points: CGFloat) {
        let currentSize = richTextLineSpacing ?? 0
        let newSize = currentSize + points
        setRichTextLineSpacing(newSize)
    }
}
