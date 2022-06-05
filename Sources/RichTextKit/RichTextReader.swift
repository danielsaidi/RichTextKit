//
//  RichTextReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 a rich text string.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextReader {

    /**
     Get the attributed string from the implementing type.
     */
    var attributedString: NSAttributedString { get }
}

extension NSAttributedString: RichTextReader {

    /**
     This type returns itself as attributed string.
     */
    public var attributedString: NSAttributedString {
        self
    }
}

public extension RichTextReader {

    /**
     Get the rich text provided by the implementing type.

     This is a convenience alias for ``attributedString`` to
     get a property that uses the rich text naming.
     */
    var richText: NSAttributedString {
        attributedString
    }

    /**
     Get the range of the entire ``richText``.

     This uses ``safeRange(for:)`` to return a safe range.
     */
    var richTextRange: NSRange {
        let range = NSRange(location: 0, length: richText.length)
        let safeRange = safeRange(for: range)
        return safeRange
    }

    /**
     Get the rich text at a certain range.

     Since this function accounts for invalid ranges, always
     use this function instead of `attributedSubstring`,

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
     */
    func safeRange(for range: NSRange) -> NSRange {
        let length = attributedString.length
        return NSRange(
            location: max(0, min(length-1, range.location)),
            length: min(range.length, max(0, length - range.location)))
    }
}
