//
//  RichTextViewComponent+Attributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {

    /// Get the current values of all rich text attributes.
    var currentRichTextAttributes: RichTextAttributes {
        if hasSelectedRange {
            return richTextAttributes(at: selectedRange)
        } else {
            #if macOS
            // TODO: If is link or any mention, set range to location and 0.
            let range = NSRange(location: selectedRange.location - 1, length: 1)
            let safeRange = safeRange(for: range)
            return richTextAttributes(at: safeRange)
            #else
            return typingAttributes
        #endif
        }
    }

    /// Get the current value of a rich text attribute.
    func currentRichTextAttribute<Value>(
        _ attribute: RichTextAttribute
    ) -> Value? {
        currentRichTextAttributes[attribute] as? Value
    }

    /// Get the current value of a rich text attribute.
    func currentCustomRichTextAttribute(
        _ attribute: RichTextAttribute
    ) -> Any? {
        currentRichTextAttributes[attribute]
    }

    /// Set the current value of a rich text attribute.
    func setTypingAttribute(_ attribute: RichTextAttribute, to value: Any?) {
        typingAttributes[attribute] = value
    }

    /// Set the current value of a rich text attribute.
    func applyToCurrentSelection(_ attribute: RichTextAttribute, to value: Any) {
        guard hasSelectedRange else { return }
        setRichTextAttribute(attribute, to: value, at: selectedRange)
    }

    // Move this to style
    func applyToCurrentSelection(_ style: RichTextStyle, to newValue: Bool) {
        guard hasSelectedRange else { return }
        let value = newValue ? 1 : 0
        switch style {
        case .bold, .italic:
            let styles = currentRichTextTypingAttributeStyles
            guard shouldAddOrRemove(style, newValue, given: styles) else { return }
            guard let font = currentFont else { return }
            guard let newFont = newFont(for: font, byToggling: style) else { return }
            setRichTextAttribute(.font, to:newFont, at: selectedRange)
        case .underlined:
            applyToCurrentSelection(.underlineStyle, to: value)
        case .strikethrough:
            applyToCurrentSelection(.strikethroughStyle, to: value)
        }
    }

    /// This sets flags in toolbar to see if the attribute is on/off.
    func appendCurrentRichTextAttributes(_ attributes: RichTextAttributes) {
        attributes.forEach { attribute, value in
            setTypingAttribute(attribute, to: value)
        }
    }
}
