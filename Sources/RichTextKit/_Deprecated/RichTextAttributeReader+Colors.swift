//
//  RichTextAttributeReader+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use RichTextViewComponent instead")
public extension RichTextAttributeReader {

    /// Get a certain rich text color at a certain range.
    func richTextColorOld(
        _ color: RichTextColor,
        at range: NSRange
    ) -> ColorRepresentable? {
        guard let attribute = color.attribute else { return nil }
        return richTextAttribute(attribute, at: range)
    }
}
