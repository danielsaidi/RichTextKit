//
//  RichTextAttributeReader+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextAttributeReader {

    /// Get the text alignment at a certain range.
    func richTextAlignment(
        at range: NSRange
    ) -> RichTextAlignment? {
        let attribute: NSMutableParagraphStyle? = richTextAttribute(.paragraphStyle, at: range)
        guard let style = attribute else { return nil }
        return RichTextAlignment(style.alignment)
    }
}
