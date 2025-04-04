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
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the rich text indent.
    var richTextIndent: CGFloat? {
        richTextParagraphStyleValue(\.headIndent)
    }

    /// Set the rich text indent.
    func setRichTextIndent(to val: CGFloat) {
        setRichTextParagraphStyleValue(\.headIndent, val)
    }

    /// Step the rich text indent.
    func stepRichTextIndent(points: CGFloat) {
        stepRichTextParagraphStyleValue(\.headIndent, points)
    }
}
