//
//  RichTextAttributeReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 rich text attribute reading capabilities.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextAttributeReader: RichTextReader {}

extension NSAttributedString: RichTextAttributeReader {}

public extension RichTextAttributeReader {

    /**
     Get a rich text attribute at the provided range.

     - Parameters:
       - attribute: The attribute to get.
       - range: The range to get the attribute from.
     */
    func richTextAttribute<Value>(
        _ attribute: RichTextAttribute,
        at range: NSRange
    ) -> Value? {
        richTextAttributes(at: range)[attribute] as? Value
    }

    /**
     Get all rich text attributes at the provided range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     This function returns an empty attributes dictionary if
     the rich text is empty, since this check will otherwise
     cause the application to crash.

     - Parameters:
       - range: The range to get attributes from.
     */
    func richTextAttributes(
        at range: NSRange
    ) -> RichTextAttributes {
        if richText.length == 0 { return [:] }
        let range = safeRange(for: range)
        return richText.attributes(at: range.location, effectiveRange: nil)
    }
}
