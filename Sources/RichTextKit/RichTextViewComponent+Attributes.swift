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
            #if os(macOS)
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

    /// Set the current value of a rich text attribute.
    func setCurrentRichTextAttribute(_ attribute: RichTextAttribute, to value: Any) {
        #if os(macOS)
        setRichTextAttribute(attribute, to: value, at: selectedRange)
        typingAttributes[attribute] = value
        #else
        if hasSelectedRange {
            setRichTextAttribute(attribute, to: value, at: selectedRange)
        } else {
            typingAttributes[attribute] = value
        }
        #endif
    }

    /// Set the values of a bunch of rich text attributes.
    func setCurrentRichTextAttributes(_ attributes: RichTextAttributes) {
        attributes.forEach { attribute, value in
            setCurrentRichTextAttribute(attribute, to: value)
        }
    }
}
