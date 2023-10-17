//
//  RichTextViewComponent+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {

    /// Get the current rich text styles.
    var currentRichTextStyles: [RichTextStyle] {
        let attributes = currentRichTextAttributes
        let traits = currentFont?.fontDescriptor.symbolicTraits
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes.isStrikethrough { styles.append(.strikethrough) }
        if attributes.isUnderlined { styles.append(.underlined) }
        return styles
    }

    /// Set the current value of a certain rich text style.
    func setCurrentRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool
    ) {
        let attributeValue = newValue ? 1 : 0
        if style == .strikethrough { return setCurrentRichTextAttribute(.strikethroughStyle, to: attributeValue) }
        if style == .underlined { return setCurrentRichTextAttribute(.underlineStyle, to: attributeValue) }
        let styles = currentRichTextStyles
        let shouldAdd = newValue && !styles.hasStyle(style)
        let shouldRemove = !newValue && styles.hasStyle(style)
        guard shouldAdd || shouldRemove else { return }
        guard let font = currentFont else { return }
        let newFont: FontRepresentable? = FontRepresentable(
            descriptor: font.fontDescriptor.byTogglingStyle(style),
            size: font.pointSize)
        guard let newFont = newFont else { return }
        setCurrentFont(newFont)
    }
}
