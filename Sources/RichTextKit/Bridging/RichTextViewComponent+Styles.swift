//
//  RichTextViewComponent+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {

    /// Get all styles.
    var richTextStyles: [RichTextStyle] {
        let attributes = richTextAttributes
        let traits = richTextFont?.fontDescriptor.symbolicTraits
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes.isStrikethrough { styles.append(.strikethrough) }
        if attributes.isUnderlined { styles.append(.underlined) }
        if attributes[.link] != nil { styles.append(.link) }
        return styles
    }

    /// Whether or not the current range has a certain style.
    func hasRichTextStyle(_ style: RichTextStyle) -> Bool {
        richTextStyles.contains(style)
    }

    /// Set a certain style.
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool
    ) {
        let value = newValue ? 1 : 0
        switch style {
        case .bold, .italic:
            let styles = richTextStyles
            guard styles.shouldAddOrRemove(style, newValue) else { return }
            guard let font = richTextFont else { return }
            guard let newFont = font.toggling(style) else { return }
            setRichTextFont(newFont)
        case .underlined:
            setRichTextAttribute(.underlineStyle, to: value)
        case .strikethrough:
            setRichTextAttribute(.strikethroughStyle, to: value)
        case .link:
            if !newValue {
                // When disabling link, remove the link attribute
                setRichTextAttribute(.link, to: NSNull())
            }
            // When enabling link, do nothing - this will be handled by the context
        }
    }

    /// Toggle a certain style.
    func toggleRichTextStyle(
        _ style: RichTextStyle
    ) {
        let hasStyle = hasRichTextStyle(style)
        setRichTextStyle(style, to: !hasStyle)
    }
}
