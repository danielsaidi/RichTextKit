//
//  RichTextAttributeWriter+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use RichTextViewComponent instead")
public extension RichTextAttributeWriter {

    /// Set a rich text style at a certain range.
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool,
        at range: NSRange
    ) {
        let value = newValue ? 1 : 0
        let range = safeRange(for: range)
        switch style {
        case .bold, .italic:
            let styles = richTextStyles(at: range)
            guard styles.shouldAddOrRemove(style, newValue) else { return }
            guard let font = richTextFont(at: range) else { return }
            guard let newFont = font.toggling(style) else { return }
            setRichTextFont(newFont, at: range)
        case .strikethrough:
            setRichTextAttribute(.strikethroughStyle, to: value, at: range)
        case .underlined:
            setRichTextAttribute(.underlineStyle, to: value, at: range)
        }
    }
}
