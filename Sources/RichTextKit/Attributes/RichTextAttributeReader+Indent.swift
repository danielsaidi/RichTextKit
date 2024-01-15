//
//  RichTextAttributeReader+Indent.swift
//  RichTextKit
//
//  Created by James Bradley on 2022-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import Foundation

public extension RichTextAttributeReader {

    /// Get the text indent in points at a certain range.
    func richTextIndent(
        at range: NSRange
    ) -> CGFloat? {
        richTextParagraphStyle(at: range)?.headIndent
    }
}
