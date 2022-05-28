//
//  RichTextTraitReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 extended rich text trait capabilities.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextTraitReader: RichTextFontReader {}

extension NSAttributedString: RichTextTraitReader {}

public extension RichTextTraitReader {

//    /**
//     Get a rich text attribute at the provided range.
//
//     The function uses `safeRange(for:)` to handle incorrect
//     ranges, which is not handled by the native functions.
//
//     - Parameters:
//       - key: The attribute to get.
//       - range: The range to get the attribute from.
//     */
//    func richTextAttribute<Value>(
//        _ key: NSAttributedString.Key,
//        at range: NSRange
//    ) -> Value? {
//        richTextAttributes(at: range)[key] as? Value
//    }
//
//    /**
//     Get all rich text attributes at the provided range.
//
//     The function uses `safeRange(for:)` to handle incorrect
//     ranges, which is not handled by the native functions.
//
//     - Parameters:
//       - range: The range to get attributes from.
//     */
//    func richTextAttributes(
//        at range: NSRange
//    ) -> [NSAttributedString.Key: Any] {
//        if richText.length == 0 { return [:] }
//        let range = safeRange(for: range)
//        return richText.attributes(at: range.location, effectiveRange: nil)
//    }

    
    /**
     Get the symbolic font traits at a certain range.

     Note that this function returns the native traits for a
     certain range. To get the corresponding ``RichTextTrait``
     collection, use

     - Parameters:
       - range: The range to get the traits from.
     */
    func symbolicTraits(at range: NSRange) -> FontDescriptor.SymbolicTraits? {
        font(at: range)?.fontDescriptor.symbolicTraits
    }
}
