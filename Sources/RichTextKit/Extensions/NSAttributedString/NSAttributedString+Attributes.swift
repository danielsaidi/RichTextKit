//
//  NSAttributedString+Attributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-23.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol is implemented by `NSAttributedString` to get
 additional rich text functionality that show up in the DocC
 generated documentation.
 */
public protocol NSAttributedStringAttributeExtension {

    /**
     Get a certain rich text attribute for a certain range.

     This function accounts for invalid ranges, which is not
     the case with `attributes(at:)`.

     - Parameters:
       - key: The attribute to get.
       - range: The range to get the attribute from.
     */
    func richTextAttribute<Value>(_ key: NSAttributedString.Key, at range: NSRange) -> Value?

    /**
     Get all text attributes for a certain range.

     This function accounts for invalid ranges, which is not
     the case with `attributes(at:)`.

     - Parameters:
       - range: The range to get attributes from.
     */
    func richTextAttributes(at range: NSRange) -> [NSAttributedString.Key: Any]
}


// MARK: - Implementation

extension NSAttributedString: NSAttributedStringAttributeExtension {}

public extension NSAttributedString {

    func richTextAttribute<Value>(_ key: Key, at range: NSRange) -> Value? {
        richTextAttributes(at: range)[key] as? Value
    }

    func richTextAttributes(at range: NSRange) -> [Key: Any] {
        if length == 0 { return [:] }
        let range = safeRange(for: range)
        return attributes(at: range.location, effectiveRange: nil)
    }
}
