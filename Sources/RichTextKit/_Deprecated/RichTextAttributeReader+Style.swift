//
//  RichTextAttributeReader+Style.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use RichTextViewComponent instead")
public extension RichTextAttributeReader {

    /// Get all rich text styles at a certain range.
    func richTextStyles(
        at range: NSRange
    ) -> [RichTextStyle] {
        let attributes = richTextAttributes(at: range)
        let traits = richTextFont(at: range)?.fontDescriptor.symbolicTraits
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes.isStrikethrough { styles.append(.strikethrough) }
        if attributes.isUnderlined { styles.append(.underlined) }
        return styles
    }
}
