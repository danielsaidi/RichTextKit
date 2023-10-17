//
//  RichTextAttributeWriter+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeWriter {

    /// Set the background color at a certain range.
    func setRichTextBackgroundColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.backgroundColor, to: color, at: range)
    }
    
    /// Set the foreground color at a certain range.
    func setRichTextForegroundColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.foregroundColor, to: color, at: range)
    }
    
    /// Set the strikethrough color at a certain range.
    func setRichTextStrikethroughColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.strikethroughColor, to: color, at: range)
    }
    
    /// Set the stroke color at a certain range.
    func setRichTextStrokeColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.strokeColor, to: color, at: range)
    }
    
    /// Set the underline color at a certain range.
    func setRichTextUnderlineColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.underlineColor, to: color, at: range)
    }
    
}
