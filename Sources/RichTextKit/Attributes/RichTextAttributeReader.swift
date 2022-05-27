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
 extended rich text attribute functionality.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextAttributeReader: RichTextReader {}

extension NSAttributedString: RichTextAttributeReader {}

public extension RichTextAttributeReader {

    /**
     Get a rich text attribute for the provided range.

     The function uses ``safeRange(for:)`` to handle invalid
     ranges, which is not the case with the native functions.

     - Parameters:
       - key: The attribute to get.
       - range: The range to get the attribute from.
     */
    func richTextAttribute<Value>(_ key: NSAttributedString.Key, at range: NSRange) -> Value? {
        richTextAttributes(at: range)[key] as? Value
    }

    /**
     Get all text attributes for the provided range.

     The function uses ``safeRange(for:)`` to handle invalid
     ranges, which is not the case with the native functions.

     - Parameters:
       - range: The range to get attributes from.
     */
    func richTextAttributes(at range: NSRange) -> [NSAttributedString.Key: Any] {
        if richText.length == 0 { return [:] }
        let range = safeRange(for: range)
        return richText.attributes(at: range.location, effectiveRange: nil)
    }
}
