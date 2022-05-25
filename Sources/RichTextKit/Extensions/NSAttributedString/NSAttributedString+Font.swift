//
//  NSAttributedString+Font.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension NSAttributedString {

    /**
     Get the font at a certain `range`.

     - Parameters:
       - range: The range to get the font from.
     */
    func font(at range: NSRange) -> FontRepresentable? {
        textAttribute(.font, at: range)
    }
}
