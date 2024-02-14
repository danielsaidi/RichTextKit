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
 for writing attributes to the ``RichTextWriter/richText`.

 This protocol is implemented by `NSMutableAttributedString`,
 as well as other types in the library.
 
 Note that this protocol used to have a lot of functionality
 for setting various attributes, styles, etc. However, since
 ``RichTextViewComponent`` needs to perform changes in other
 ways, we ended up with duplicated code where the writer had
 functions that may have worked, but weren't used within the
 library. As such, the ``RichTextViewComponent`` will be the
 primary component for modifying rich text, while the writer
 functionality is removed. This will help to avoid confusion.
 */
public protocol RichTextAttributeWriter: RichTextWriter, RichTextAttributeReader {}

extension NSMutableAttributedString: RichTextAttributeWriter {}

public extension RichTextAttributeWriter {

    /// Set a certain rich text attribute at a certain range.
    func setRichTextAttribute(
        _ attribute: RichTextAttribute,
        to newValue: Any,
        at range: NSRange
    ) {
        setRichTextAttributes([attribute: newValue], at: range)
    }

    /// Set certain rich text attributes at a certain range.
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
