//
//  RichTextAttributeWriter+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeWriter {

    /// Set a certain rich text color at the provided range.
    func setRichTextColor(
        _ color: RichTextColor,
        to val: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        guard let attribute = color.attribute else { return }
        if richTextColor(color, at: range) == val { return }
        setRichTextAttribute(attribute, to: val, at: range)
    }
}
