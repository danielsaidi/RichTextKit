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
public protocol RichTextIndentReader: RichTextAttributeReader {
    func richTextIndent(at index: Int) -> CGFloat
}

extension NSAttributedString: RichTextIndentReader {}

public extension RichTextIndentReader {

    func richTextIndent(at index: Int) -> CGFloat {
        let range = NSRange(location: index, length: 0)
        let attribute: NSMutableParagraphStyle? = richTextAttribute(.paragraphStyle, at: range)
        return attribute?.headIndent ?? 0
    }
}
