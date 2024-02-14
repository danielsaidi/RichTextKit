//
//  RichTextAttributeWriter+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

@available(*, deprecated, message: "Use RichTextViewComponent instead.")
public extension RichTextAttributeWriter {

    /// Set the rich text alignment at a certain range.
    func setRichTextAlignment(
        _ alignment: RichTextAlignment,
        at range: NSRange
    ) {
        let paragraph = richTextParagraphStyle(at: range) ?? .init()
        paragraph.alignment = alignment.nativeAlignment
        setRichTextParagraphStyle(to: paragraph, at: range)
    }
}
