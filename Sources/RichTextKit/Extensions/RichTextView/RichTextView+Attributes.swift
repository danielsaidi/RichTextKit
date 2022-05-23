//
//  RichTextView+Attributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)
import Foundation

public extension RichTextView {

    /**
     Get a certain text attribute for a certain range.

     - Parameters:
       - key: The attribute to get.
       - range: The range to get the attribute from.
     */
    func textAttribute<Value>(_ key: NSAttributedString.Key, at range: NSRange) -> Value? {
        attributedString.textAttribute(key, at: range)
    }

    /**
     Get all text attributes for a certain range.

     - Parameters:
       - range: The range to get attributes from.
     */
    func textAttributes(at range: NSRange) -> [NSAttributedString.Key: Any] {
        attributedString.textAttributes(at: range)
    }
}
#endif
