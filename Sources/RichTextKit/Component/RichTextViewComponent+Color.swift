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
        case .foreground: currentRichTextAttribute(.foregroundColor)
        case .background: currentRichTextAttribute(.backgroundColor)
        case .strikethrough: currentRichTextAttribute(.strikethroughColor)
        case .stroke: currentRichTextAttribute(.strokeColor)
        case .undefined: nil
        }
    }

    /// Set the current value of a certain color.
    func setCurrentColor(
        _ color: RichTextColor,
        to val: ColorRepresentable
    ) {
        if currentColor(color) == val { return }
        switch color {
        case .foreground: setTypingAttribute(.foregroundColor, to: val)
        case .background: setTypingAttribute(.backgroundColor, to: val)
        case .strikethrough: setTypingAttribute(.strikethroughColor, to: val)
        case .stroke: setTypingAttribute(.strokeColor, to: val)
        case .undefined: return
        }
    }
}
