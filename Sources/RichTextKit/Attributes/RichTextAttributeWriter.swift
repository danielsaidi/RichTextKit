//
//  RichTextAttributeWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 extended rich text attribute write functionality.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextAttributeWriter: RichTextWriter {}

extension NSMutableAttributedString: RichTextAttributeWriter {}

public extension RichTextAttributeWriter {

    /**
     Set a certain text attribute value for a certain range.

     This function accounts for invalid ranges, which is not
     the case with `enumerateAttribute(...)` and other range
     based operations.

     - Parameters:
       - key: The attribute key to set.
       - newValue: The new value to set the attribute to.
       - range: The range for which to set the attribute.
     */
    func setTextAttribute(_ key: NSAttributedString.Key, to newValue: Any, at range: NSRange) {
        let range = safeRange(for: range)
        guard let string = mutableAttributedString else { return }
        guard string.length > 0, range.location >= 0 else { return }
        string.beginEditing()
        string.enumerateAttribute(key, in: range, options: .init()) { value, range, _ in
            string.removeAttribute(key, range: range)
            string.addAttribute(key, value: newValue, range: range)
            string.fixAttributes(in: range)
        }
        string.endEditing()
    }
}
