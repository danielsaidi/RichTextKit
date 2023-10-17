//
//  RichTextAttributeWriter+Colors.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextAttributeWriter {

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
