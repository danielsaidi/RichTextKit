//
//  RichTextAttributeWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol extends the ``RichTextWriter`` protocol to
/// make any implementing type able to set attributes in the
/// ``RichTextReader/richText`` property.
///
/// This protocol is implemented by `NSAttributedString` and
/// other types in the library.
///
/// > Note: The protocol used to have a lot of functionality
/// for getting various attributes, styles, etc. However, it
/// caused duplicated code since the ``RichTextViewComponent``
/// needed more capabilities as well. As such, this protocol
/// is now limited in functionality.
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
