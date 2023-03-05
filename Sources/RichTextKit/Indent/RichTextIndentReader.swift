//
//  RichTextIndentReader.swift
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
 text indent-specific functionality.

 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextIndentReader: RichTextAttributeReader {}

extension NSAttributedString: RichTextIndentReader {}

public extension RichTextIndentReader {

    /**
     Get the rich text indent at the provided range.

     - Parameters:
       - range: The range to get the indent from.
     */
    func richTextIndent(
        at range: NSRange
    ) -> RichTextIndent? {
        let attribute: NSMutableParagraphStyle? = richTextAttribute(.paragraphStyle, at: range)
        guard let style = attribute else { return nil }
        return RichTextIndent(rawValue: style.headIndent)
    }
}
