//
//  RichTextColorReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol extends ``RichTextAttributeReader`` with rich
 text color-specific functionality.

 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextColorReader: RichTextAttributeReader {}

extension NSAttributedString: RichTextColorReader {}

public extension RichTextColorReader {

    /**
     Get the background color at the provided range.

     - Parameters:
       - range: The range to get the color from.
     */
    func backgroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.backgroundColor, at: range)
    }

    /**
     Get the foreground color at the provided range.

     - Parameters:
       - range: The range to get the color from.
     */
    func foregroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.foregroundColor, at: range)
    }
}
