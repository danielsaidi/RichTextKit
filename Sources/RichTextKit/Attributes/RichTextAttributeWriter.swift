//
//  RichTextAttributeWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol extends ``RichTextWriter`` with functionality
 for writing rich text attributes to the current rich text.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other types in the library.
 */
public protocol RichTextAttributeWriter: RichTextWriter, RichTextAttributeReader {}

extension NSMutableAttributedString: RichTextAttributeWriter {}

public extension RichTextAttributeWriter {

    /**
     Set a certain rich text attribute to a certain value at
     the provided range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     - Parameters:
       - attribute: The attribute to set.
       - newValue: The new value to set the attribute to.
       - range: The range to affect, by default the entire text.
     */
    func setRichTextAttribute(
        _ attribute: RichTextAttribute,
        to newValue: Any,
        at range: NSRange? = nil
    ) {
        setRichTextAttributes([attribute: newValue], at: range)
    }

    /**
     Set a set of rich text attributes at the provided range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     - Parameters:
       - attributes: The attributes to set.
       - range: The range to affect, by default the entire text.
     */
    func setRichTextAttributes(
        _ attributes: RichTextAttributes,
        at range: NSRange? = nil
    ) {
        let rangeValue = range ?? richTextRange
        let range = safeRange(for: rangeValue)
        guard let string = mutableRichText else { return }
        string.beginEditing()
        attributes.forEach { attribute, newValue in
            string.enumerateAttribute(attribute, in: range, options: .init()) { _, range, _ in
                string.removeAttribute(attribute, range: range)
                string.addAttribute(attribute, value: newValue, range: range)
                string.fixAttributes(in: range)
            }
        }
        string.endEditing()
    }
}
