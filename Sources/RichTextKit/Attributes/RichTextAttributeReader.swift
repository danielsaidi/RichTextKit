//
//  RichTextAttributeReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol extends ``RichTextReader`` with functionality
 for reading rich text attributes for the current rich text.

 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextAttributeReader: RichTextReader {}

extension NSAttributedString: RichTextAttributeReader {}

public extension RichTextAttributeReader {

    /// Get a rich text attribute at a certain range.
    func richTextAttribute<Value>(
        _ attribute: RichTextAttribute,
        at range: NSRange
    ) -> Value? {
        richTextAttributes(at: range)[attribute] as? Value
    }
    
    /// Get all rich text attributes at a certain range.
    func richTextAttributes(
        at range: NSRange
    ) -> RichTextAttributes {
        if richText.length == 0 { return [:] }
        let range = safeRange(for: range, isAttributeOperation: true)
        return richText.attributes(at: range.location, effectiveRange: nil)
    }
}
