//
//  RichTextAttributeReader+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Foundation

public extension RichTextAttributeReader {

    /**
     Get the font at a certain range.

     - Parameters:
       - range: The range to get the font from.
     */
    func font(at range: NSRange) -> FontRepresentable? {
        richTextAttribute(.font, at: range)
    }

    /**
     Get the font size at a certain range.

     - Parameters:
       - range: The range to get the font size from.
     */
    func fontSize(at range: NSRange) -> CGFloat? {
        font(at: range)?.pointSize
    }
}
