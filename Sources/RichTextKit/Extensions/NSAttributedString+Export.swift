//
//  NSAttributedString+Export.swift
//  OribiRichTextKit
//
//  Created by Daniel Saidi on 2022-04-05.
//  Copyright © 2022 Oribi. All rights reserved.
//

import Foundation

extension NSAttributedString {

    /**
     Make all text in the attributed string black to account
     for dark mode. This is internal, since we don't want to
     have to do it this way.
     */
    func withBlackText() -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        let range = mutable.safeRange(for: NSRange(location: 0, length: mutable.length))
        mutable.setRichTextAttribute(.foregroundColor, to: ColorRepresentable.black, at: range)
        return mutable
    }
}
