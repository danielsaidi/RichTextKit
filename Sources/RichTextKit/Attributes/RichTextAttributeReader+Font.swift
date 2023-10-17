//
//  RichTextAttributeReader+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeReader {

    /// Get the font at a certain range.
    func richTextFont(at range: NSRange) -> FontRepresentable? {
        richTextAttribute(.font, at: range)
    }

    /// Get the font size (in points) at a certain range.
    func richTextFontSize(at range: NSRange) -> CGFloat? {
        richTextFont(at: range)?.pointSize
    }
}
