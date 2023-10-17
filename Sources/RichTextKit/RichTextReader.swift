//
//  RichTextReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 a rich text string.

 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextReader {

    /// The attributed string to use as rich text.
    var attributedString: NSAttributedString { get }
}

extension NSAttributedString: RichTextReader {

    /// This type returns itself as the attributed string.
    public var attributedString: NSAttributedString { self }
}

public extension RichTextReader {

    /**
     The rich text to use.

     This is a convenience name alias for ``attributedString``
     to provide this type with a property that uses the rich
     text naming convention.
     */
    var richText: NSAttributedString {
        attributedString
    }

    /**
     Get the range of the entire ``richText``.

     This uses `safeRange(for:)` to return a range that willö
     always be valid for the current rich text.
     */
    var richTextRange: NSRange {
        let range = NSRange(location: 0, length: richText.length)
        let safeRange = safeRange(for: range)
        return safeRange
    }

    /**
     Get the rich text at a certain range.

     Since this function uses `safeRange(for:)` to not crash
     for invalid ranges, always use this function instead of
     the unsafe `attributedSubstring`.

     - Parameters:
       - range: The range for which to get the rich text.
     */
    func richText(at range: NSRange) -> NSAttributedString {
        let range = safeRange(for: range)
        return attributedString.attributedSubstring(from: range)
    }

    /**
     Get a safe range for the provided range.

     A safe range is limited to the bounds of the attributed
     string and helps protecting against range overflow.

     - Parameters:
       - range: The range for which to get a safe range.
       - isAttributeOperation: Set this to `true` to avoid last position.
     */
    func safeRange(
        for range: NSRange,
        isAttributeOperation: Bool = false
    ) -> NSRange {
        let length = attributedString.length
        let subtract = isAttributeOperation ? 1 : 0
        return NSRange(
            location: max(0, min(length - subtract, range.location)),
            length: min(range.length, max(0, length - range.location)))
    }
}
