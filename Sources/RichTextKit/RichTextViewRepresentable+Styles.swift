//
//  RichTextViewRepresentable+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewRepresentable {

    /**
     Use the selected range (if any) or text position to set
     a certain rich text style.

     - Parameters:
       - style: The style to set.
       - newValue: The value to set.
     */
    func setCurrentRichTextStyle(_ style: RichTextStyle, to newValue: Bool) {
        let range = selectedRange
        let styles = richTextStyles(at: range)
        let isSet = styles.hasStyle(style)
        if newValue == isSet { return }
        setRichTextStyle(style, to: newValue, at: range)
    }
}
