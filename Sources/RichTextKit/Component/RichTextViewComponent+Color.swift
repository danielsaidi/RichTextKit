//
//  RichTextViewComponent+Color.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension RichTextViewComponent {

    /// Get the current value of a certain rich text color.
    func currentColor(
        _ color: RichTextColor
    ) -> ColorRepresentable? {
        guard let attribute = color.attribute else { return nil }
        return currentRichTextAttribute(attribute)
    }

    /// Set the current value of a certain rich text color.
    func setCurrentColor(
        _ color: RichTextColor,
        to val: ColorRepresentable
    ) {
        if currentColor(color) == val { return }
        guard let attribute = color.attribute else { return }
        setCurrentRichTextAttribute(attribute, to: val)
    }
}
