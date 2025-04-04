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

    @available(*, deprecated, message: "Use richTextParagraphStyleValue(\\.lineSpacing) instead.")
    var richTextLineSpacing: CGFloat? {
        richTextParagraphStyleValue(\.lineSpacing)
    }

    @available(*, deprecated, message: "Use setRichTextParagraphStyleValue(\\.lineSpacing, ...) instead.")
    func setRichTextLineSpacing(_ spacing: CGFloat) {
        setRichTextParagraphStyleValue(\.lineSpacing, spacing)
    }

    @available(*, deprecated, message: "Use stepRichTextParagraphStyleValue(\\.lineSpacing, ...) instead.")
    func stepRichTextLineSpacing(points: CGFloat) {
        stepRichTextParagraphStyleValue(\.lineSpacing, points)
    }
}
