//
//  RichTextViewRepresentable+Attributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewRepresentable {

    /**
     Use the selected range (if any) or text position to get
     all rich text attribute values.

     AppKit and UIKit handles this differently, which is why
     the implementation has different branches.
     */
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

    /**
     Use the selected range (if any) or text position to get
     the current value of a certain rich text attribute.
     */
    func currentRichTextAttribute<Value>(_ attribute: RichTextAttribute) -> Value? {
        currentRichTextAttributes[attribute] as? Value
    }

    /**
     Use the selected range (if any) or text position to set
     the current value of a certain rich text attribute.

     AppKit and UIKit handles this differently, which is why
     the implementation has different branches.

     - Parameters:
       - attribute: The attribute to set.
       - value: The value to set the attribute to.
     */
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

    /**
     Use the selected range (if any) or text position to set
     the current rich text attributes.

     AppKit and UIKit handles this differently, which is why
     the implementation has different branches.

     - Parameters:
       - attributes: The attributes to set.
     */
    func setCurrentRichTextAttributes(_ attributes: RichTextAttributes) {
        attributes.forEach { attribute, value in
            setCurrentRichTextAttribute(attribute, to: value)
        }
    }
}
