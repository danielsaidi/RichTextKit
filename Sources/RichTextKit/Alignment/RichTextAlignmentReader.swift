//
//  RichTextAlignmentReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/**
 This protocol extends ``RichTextAttributeReader`` with rich
 text alignment-specific functionality.

 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextAlignmentReader: RichTextAttributeReader {}

extension NSAttributedString: RichTextAlignmentReader {}

public extension RichTextAlignmentReader {

    /**
     Get the rich text alignment at a certain range.

     - Parameters:
       - range: The range to get the alignment from.
     */
    func richTextAlignment(
        at range: NSRange
    ) -> RichTextAlignment? {
        let attribute: NSMutableParagraphStyle? = richTextAttribute(.paragraphStyle, at: range)
        guard let style = attribute else { return nil }
        return RichTextAlignment(style.alignment)
    }
}
