//
//  RichTextAttributeReader+Indent.swift
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

public extension RichTextAttributeReader {

    /**
     Get the rich text indent level at the provided range.

     - Parameters:
       - range: The range to get the indent from.
     */
    func richTextIndent(
        at range: NSRange
    ) -> CGFloat? {
        let attribute: NSMutableParagraphStyle? = richTextAttribute(.paragraphStyle, at: range)
        guard let style = attribute else { return nil }
        return style.headIndent
    }
}
