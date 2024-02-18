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

    /// Get the rich text indent.
    var richTextIndent: CGFloat? {
        richTextParagraphStyle?.headIndent
    }
    
    /// Set the rich text indent.
    func setRichTextIndent(to val: CGFloat) {
        let style = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            indent: val
        )
        setRichTextParagraphStyle(style)
    }

    /// Step the rich text indent.
    func stepRichTextIndent(points: CGFloat) {
        let old = richTextParagraphStyle?.headIndent ?? 0
        let indent = max(0, old + points)
        setRichTextIndent(to: indent)
    }
}
