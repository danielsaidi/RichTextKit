//
//  RichTextAttributeReader+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use RichTextViewComponent instead.")
public extension RichTextAttributeReader {

    /// Get the rich text font at a certain range.
    func richTextFont(
        at range: NSRange
    ) -> FontRepresentable? {
        richTextAttribute(.font, at: range)
    }
}
