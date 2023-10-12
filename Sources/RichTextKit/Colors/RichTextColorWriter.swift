//
//  RichTextColorWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol extends ``RichTextAttributeWriter`` with rich
 text color writing functionality.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other types in the library.
 */
public protocol RichTextColorWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextColorWriter {}

public extension RichTextColorWriter {

    /**
     Set the background color at the provided range.

     - Parameters:
       - color: The color to set.
       - range: The range to affect, by default the entire text.
     */
    func setBackgroundColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.backgroundColor, to: color, at: range)
    }

    /**
     Set the foreground color at the provided range.

     - Parameters:
       - color: The color to set.
       - range: The range to affect, by default the entire text.
     */
    func setForegroundColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.foregroundColor, to: color, at: range)
    }
}
