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

    @available(*, deprecated, message: "Use richTextParagraphStyleValue(\\.headIndent) instead.")
    var richTextIndent: CGFloat? {
        richTextParagraphStyleValue(\.headIndent)
    }

    @available(*, deprecated, message: "Use setRichTextParagraphStyleValue(\\.headIndent, ...) instead.")
    func setRichTextIndent(to val: CGFloat) {
        setRichTextParagraphStyleValue(\.headIndent, val)
    }

    @available(*, deprecated, message: "Use stepRichTextParagraphStyleValue(\\.headIndent, ...) instead.")
    func stepRichTextIndent(points: CGFloat) {
        stepRichTextParagraphStyleValue(\.headIndent, points)
    }
}
