//
//  RichTextViewRepresentable+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewRepresentable {

    /**
     Use the selected range (if any) or text position to get
     the current rich text styles.
     */
    var currentRichTextStyles: [RichTextStyle] {
        let attributes = currentRichTextAttributes
        let traits = currentFont?.fontDescriptor.symbolicTraits
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes.isUnderlined { styles.append(.underlined) }
        return styles
    }

    /**
     Use the selected range (if any) or text position to set
     the current value for a certain rich text style.

     `TODO` This function reuses a lot of functionality from
     `setRichTextStyle(_:to:at:)`. Try reuse some of it when
     we have unit tests in place.

     - Parameters:
       - style: The style to set.
       - newValue: The value to set.
     */
    func setCurrentRichTextStyle(_ style: RichTextStyle, to newValue: Bool) {
        let attributeValue = newValue ? 1 : 0
        if style == .underlined { return setCurrentRichTextAttribute(.underlineStyle, to: attributeValue) }
        let styles = currentRichTextStyles
        let shouldAdd = newValue && !styles.hasStyle(style)
        let shouldRemove = !newValue && styles.hasStyle(style)
        guard shouldAdd || shouldRemove else { return }
        guard let font = currentFont else { return }
        let newFont: FontRepresentable? = FontRepresentable(
            descriptor: font.fontDescriptor.byTogglingStyle(style),
            size: font.pointSize)
        guard let newFontValue = newFont else { return }
        setCurrentFont(to: newFontValue)
    }
}
