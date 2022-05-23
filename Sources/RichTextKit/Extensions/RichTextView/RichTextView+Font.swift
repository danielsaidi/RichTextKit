//
//  RichTextView+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(macOS)
import Foundation

public extension RichTextView {

    /**
     Get the font at a certain `range`.

     - Parameters:
       - range: The range to get the font from.
     */
    func font(at range: NSRange) -> FontRepresentable? {
        attributedString.font(at: range)
    }
}
#endif
