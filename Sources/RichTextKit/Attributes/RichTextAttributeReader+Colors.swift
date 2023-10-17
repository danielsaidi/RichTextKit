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
}
