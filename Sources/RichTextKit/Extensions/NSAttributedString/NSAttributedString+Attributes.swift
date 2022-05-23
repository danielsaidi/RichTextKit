//
//  NSAttributedString+Attributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-23.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension NSAttributedString {

    /**
     Get a certain text attribute for a certain range.

     This function accounts for invalid ranges, which is not
     the case with `attributes(at:)`.

     - Parameters:
       - key: The attribute to get.
       - range: The range to get the attribute from.
     */
    func textAttribute<Value>(_ key: Key, at range: NSRange) -> Value? {
        textAttributes(at: range)[key] as? Value
    }

    /**
     Get all text attributes for a certain range.

     This function accounts for invalid ranges, which is not
     the case with `attributes(at:)`.

     - Parameters:
       - range: The range to get attributes from.
     */
    func textAttributes(at range: NSRange) -> [Key: Any] {
        if length == 0 { return [:] }
        let range = safeRange(for: range)
        return attributes(at: range.location, effectiveRange: nil)
    }
}
