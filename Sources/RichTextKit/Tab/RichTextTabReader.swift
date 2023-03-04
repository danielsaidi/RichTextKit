//
//  RichTextTabReader.swift
//  RichTextKit
//
//  Created by James Bradley on 2022-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
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
 text tab-specific functionality.

 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextTabReader: RichTextAttributeReader {}

extension NSAttributedString: RichTextTabReader {}

public extension RichTextTabReader {

    /**
     Get the rich text tab at the provided range.

     - Parameters:
       - range: The range to get the tab from.
     */
    func richTextTab(
        at range: NSRange
    ) -> RichTextTab? {
        let attribute: NSMutableParagraphStyle? = richTextAttribute(.paragraphStyle, at: range)
        guard let style = attribute else { return nil }
        return RichTextTab(1)
    }
}
