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
 This protocol can be implemented any types that can provide
 rich text alignment reading capabilities.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextAlignmentReader: RichTextAttributeReader {}

extension NSAttributedString: RichTextAlignmentReader {}

public extension RichTextAlignmentReader {

    /**
     Get the rich text alignment at the provided range.

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
