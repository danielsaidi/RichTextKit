//
//  RichTextAttributeReader+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeReader {

    /// Get a certain rich text color at the provided range.
    func richTextColor(
        _ color: RichTextColor,
        at range: NSRange? = nil
    ) -> ColorRepresentable? {
        guard let attribute = color.attribute else { return nil }
        return richTextAttribute(attribute, at: range)
    }
}
