//
//  RichTextAttributeWriter+Style.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeWriter {

    /**
     Set a rich text style at a certain range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     > Note: When adding logic to the function, make sure to
     also adjust `setCurrentRichTextStyle`.

     - Parameters:
       - style: The style to set.
       - newValue: The new value to set the attribute to.
       - range: The range to affect, by default the entire text.
     */
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool,
        at range: NSRange? = nil
    ) {
        let value = newValue ? 1 : 0
        let range = safeRange(for: range ?? richTextFullRange)
        switch style {
        case .bold, .italic:
            let styles = richTextStyles(at: range)
            guard shouldAddOrRemove(style, newValue, given: styles) else { return }
            guard let font = richTextFont(at: range) else { return }
            guard let newFont = newFont(for: font, byToggling: style) else { return }
            setRichTextFont(newFont, at: range)
        case .strikethrough:
            setRichTextAttribute(.strikethroughStyle, to: value, at: range)
        case .underlined:
            setRichTextAttribute(.underlineStyle, to: value, at: range)
        }
    }
}

extension RichTextAttributeWriter {

    func newFont(
        for font: FontRepresentable,
        byToggling style: RichTextStyle
    ) -> FontRepresentable? {
        FontRepresentable(
            descriptor: font.fontDescriptor.byTogglingStyle(style),
            size: font.pointSize
        )
    }

    func shouldAddOrRemove(
        _ style: RichTextStyle,
        _ newValue: Bool,
        given styles: [RichTextStyle]
    ) -> Bool {
        let shouldAdd = newValue && !styles.hasStyle(style)
        let shouldRemove = !newValue && styles.hasStyle(style)
        return shouldAdd || shouldRemove
    }
}
