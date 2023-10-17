//
//  RichTextAttributeReader+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeReader {

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
