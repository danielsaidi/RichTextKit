//
//  NSAttributedString+Export.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-04-05.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

@MainActor
extension NSAttributedString {

    /// Make all text black to account for dark mode.
    func withBlackText() -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        let range = mutable.safeRange(for: NSRange(location: 0, length: mutable.length))
        mutable.setRichTextAttribute(.foregroundColor, to: ColorRepresentable.black, at: range)
        return mutable
    }
}
