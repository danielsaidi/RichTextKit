//
//  RichTextReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

/// This protocol can be implemented by any type that can be
/// used to access an ``attributedString``.
@preconcurrency @MainActor
public protocol RichTextReader {

    /// The attributed string.
    var attributedString: NSAttributedString { get }
}

extension NSAttributedString: RichTextReader {

    /// This type returns itself as the attributed string.
    public var attributedString: NSAttributedString { self }
}

public extension RichTextReader {

    /// The rich text.
    ///
    /// This is a name alias for ``attributedString``.
    var richText: NSAttributedString {
        attributedString
    }

    /// The full range of the entire ``richText``.
    ///
    /// This will use ``safeRange(for:isAttributeOperation:)``
    /// to return a range that is always valid for this text.
    var richTextRange: NSRange {
        let range = NSRange(location: 0, length: richText.length)
        let safeRange = safeRange(for: range)
        return safeRange
    }

    /// The rich text at a certain range.
    ///
    /// This will use ``safeRange(for:isAttributeOperation:)``
    /// to return a range that is always valid for the range,
    /// so use it instead of the unsafe `attributedSubstring`.
    ///
    /// - Parameters:
    ///   - range: The range for which to get the rich text.
    func richText(at range: NSRange) -> NSAttributedString {
        let range = safeRange(for: range)
        return attributedString.attributedSubstring(from: range)
    }

    /// Get a safe range for the provided range.
    ///
    /// This range is capped to the bounds of the attributed
    /// string and helps protecting against range overflow.
    ///
    /// - Parameters:
    ///   - range: The range for which to get a safe range.
    ///   - isAttributeOperation: Set this to `true` to avoid last position.
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
