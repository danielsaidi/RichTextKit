//
//  RichTextAttributeReader+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeReader {

    /// Get the text alignment at a certain range.
    func richTextAlignment(
        at range: NSRange
    ) -> RichTextAlignment? {
        let style = richTextParagraphStyle(at: range)
        guard let style = style else { return nil }
        return RichTextAlignment(style.alignment)
    }
}
