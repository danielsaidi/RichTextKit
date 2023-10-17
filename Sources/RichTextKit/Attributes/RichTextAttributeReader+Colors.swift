//
//  RichTextAttributeReader+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeReader {

    /// Get the background color at a certain range.
    func richTextBackgroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.backgroundColor, at: range)
    }
    
    /// Get the foreground color at a certain range.
    func richTextForegroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.foregroundColor, at: range)
    }
    
    /// Get the strikethrough color at a certain range.
    func richTextStrikethroughColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.strikethroughColor, at: range)
    }
    
    /// Get the stroke color at a certain range.
    func richTextStrokeColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.strokeColor, at: range)
    }
    
    /// Get the underline color at a certain range.
    func richTextUnderlineColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.underlineColor, at: range)
    }
}
