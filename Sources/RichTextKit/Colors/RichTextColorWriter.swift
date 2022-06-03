//
//  RichTextColorWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 rich text color writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextColorWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextColorWriter {}

public extension RichTextColorWriter {

    /**
     Set the background color at the provided range.

     - Parameters:
       - color: The color to set.
       - range: The range for which to set the color.
     */
    func setBackgroundColor(
        to color: ColorRepresentable,
        at range: NSRange
    ) {
        setRichTextAttribute(.backgroundColor, to: color, at: range)
    }

    /**
     Set the foreground color at the provided range.

     - Parameters:
       - color: The color to set.
       - range: The range for which to set the color.
     */
    func setForegroundColor(
        to color: ColorRepresentable,
        at range: NSRange
    ) {
        setRichTextAttribute(.foregroundColor, to: color, at: range)
    }
}
