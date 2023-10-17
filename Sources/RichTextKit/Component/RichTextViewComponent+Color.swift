//
//  RichTextViewComponent+Color.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {
    
    /// Get the current value of a certain color.
    func currentColor(
        _ color: RichTextColor
    ) -> ColorRepresentable? {
        switch color {
        case .foreground:
            return currentRichTextAttribute(.foregroundColor)
        case .background:
            return currentRichTextAttribute(.backgroundColor)
        case .strikethrough:
            return currentRichTextAttribute(.strikethroughColor)
        case .stroke:
            return currentRichTextAttribute(.strokeColor)
        }
    }
    
    /// Set the current value of a certain color.
    func setCurrentColor(
        _ color: RichTextColor,
        to val: ColorRepresentable
    ) {
        if currentColor(color) == val { return }
        switch color {
        case .foreground:
            setCurrentRichTextAttribute(.foregroundColor, to: val)
        case .background:
            setCurrentRichTextAttribute(.backgroundColor, to: val)
        case .strikethrough:
            setCurrentRichTextAttribute(.strikethroughColor, to: val)
        case .stroke:
            setCurrentRichTextAttribute(.strokeColor, to: val)
        }
    }
}
