//
//  RichTextTraitWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 extended rich text trait writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextTraitWriter: RichTextFontWriter {}

extension NSMutableAttributedString: RichTextTraitWriter {}

public extension RichTextTraitWriter {

//    /**
//     Set a certain rich text attribute to a certain value at
//     a certain range.
//
//     The function uses `safeRange(for:)` to handle incorrect
//     ranges, which is not handled by the native functions.
//
//     - Parameters:
//       - key: The attribute key to set.
//       - newValue: The new value to set the attribute to.
//       - range: The range for which to set the attribute.
//     */
//    func setRichTextAttribute(
//        _ key: NSAttributedString.Key,
//        to newValue: Any,
//        at range: NSRange
//    ) {
//        let range = safeRange(for: range)
//        guard let string = mutableRichText else { return }
//        guard string.length > 0, range.location >= 0 else { return }
//        string.beginEditing()
//        string.enumerateAttribute(key, in: range, options: .init()) { value, range, _ in
//            string.removeAttribute(key, range: range)
//            string.addAttribute(key, value: newValue, range: range)
//            string.fixAttributes(in: range)
//        }
//        string.endEditing()
//    }
}
