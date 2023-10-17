//
//  RichTextAttributeReader+Paragraph.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-17.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextAttributeReader {

    /// Get the paragraph style at a certain range.
    func richTextParagraphStyle(
        at range: NSRange
    ) -> NSMutableParagraphStyle? {
        richTextAttribute(.paragraphStyle, at: range)
    }
}
