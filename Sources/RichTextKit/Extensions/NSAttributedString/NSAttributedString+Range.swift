//
//  NSAttributedString+Range.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-23.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    
    /**
     Get the rich text at a certain `range`.
     
     Since this function accounts for invalid ranges, always
     use this function instead of `attributedSubstring`,

     - Parameters:
       - range: The range to get the rich text from.
     */
    func richText(at range: NSRange) -> NSAttributedString {
        let range = safeRange(for: range)
        return attributedSubstring(from: range)
    }
    
    /**
     Get a safe range for the provided range. This will help
     protecting if the range is outside the text bounds.

     - Parameters:
       - range: The range for which to get a safe range.
     */
    func safeRange(for range: NSRange) -> NSRange {
        NSRange(
            location: max(0, min(length-1, range.location)),
            length: min(range.length, max(0, length - range.location)))
    }
}
