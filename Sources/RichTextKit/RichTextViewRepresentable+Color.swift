//
//  RichTextViewRepresentable+Color.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewRepresentable {

    /**
     Use the selected range (if any) or text position to get
     the current background color alignment.
     */
    var currentBackgroundColor: ColorRepresentable? {
        currentRichTextAttribute(.backgroundColor)
    }

    /**
     Use the selected range (if any) or text position to get
     the current foreground color alignment.
     */
    var currentForegroundColor: ColorRepresentable? {
        currentRichTextAttribute(.foregroundColor)
    }

    /**
     Use the selected range (if any) or text position to set
     the current background color.

     - Parameters:
       - color: The color to set.
     */
    func setCurrentBackgroundColor(
        to color: ColorRepresentable
    ) {
        setCurrentRichTextAttribute(.backgroundColor, to: color)
    }

    /**
     Use the selected range (if any) or text position to set
     the current foreground color.

     - Parameters:
       - color: The color to set.
     */
    func setCurrentForegroundColor(
        to color: ColorRepresentable
    ) {
        setCurrentRichTextAttribute(.foregroundColor, to: color)
    }
}
