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

    /**
     Set the current value of a certain rich text style.
     
     > Note: When adding logic to the function, make sure to
     also adjust ``setRichTextStyle(_:to:at:)``.
     */
    func setCurrentRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool
    ) {
        let value = newValue ? 1 : 0
        switch style {
        case .bold, .italic:
            let styles = currentRichTextStyles
            guard shouldAddOrRemove(style, newValue, given: styles) else { return }
            guard let font = currentFont else { return }
            guard let newFont = newFont(for: font, byToggling: style) else { return }
            setCurrentFont(newFont)
        case .underlined:
            setCurrentRichTextAttribute(.underlineStyle, to: value)
        case .strikethrough:
            setCurrentRichTextAttribute(.strikethroughStyle, to: value)
        }
    }
}
