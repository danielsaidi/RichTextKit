//
//  NSMutableAttributedString+Attributes.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-23.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension NSMutableAttributedString {
    
    /**
     Set a certain text attribute value for a certain range.

     This function accounts for invalid ranges, which is not
     the case with `enumerateAttribute(...)` and other range
     based operations.
     */
    func setTextAttribute(_ key: Key, to newValue: Any, for range: NSRange) {
        let range = safeRange(for: range)
        guard length > 0, range.location >= 0 else { return }
        beginEditing()
        enumerateAttribute(key, in: range, options: .init()) { value, range, _ in
            removeAttribute(key, range: range)
            addAttribute(key, value: newValue, range: range)
            fixAttributes(in: range)
        }
        endEditing()
    }
}
