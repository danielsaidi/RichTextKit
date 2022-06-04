//
//  RichTextAttributeWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 rich text attribute writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextAttributeWriter: RichTextWriter {}

extension NSMutableAttributedString: RichTextAttributeWriter {}

public extension RichTextAttributeWriter {

    /**
     Set a certain rich text attribute to a certain value at
     a certain range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     - Parameters:
       - attribute: The attribute to set.
       - newValue: The new value to set the attribute to.
       - range: The range for which to set the attribute.
     */
    func setRichTextAttribute(
        _ attribute: RichTextAttribute,
        to newValue: Any,
        at range: NSRange
    ) {
        setRichTextAttributes([attribute: newValue], at: range)
    }

    /**
     Set a set of rich text attributes at a certain range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     - Parameters:
       - attributes: The attributes to set.
       - range: The range for which to set the attributes.
     */
    func setRichTextAttributes(
        _ attributes: RichTextAttributes,
        at range: NSRange
    ) {
        let range = safeRange(for: range)
        guard let string = mutableRichText else { return }
        string.beginEditing()
        attributes.forEach { attribute, newValue in
            string.enumerateAttribute(attribute, in: range, options: .init()) { value, range, _ in
                string.removeAttribute(attribute, range: range)
                string.addAttribute(attribute, value: newValue, range: range)
                string.fixAttributes(in: range)
            }
        }
        string.endEditing()
    }
}
