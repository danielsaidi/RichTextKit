//
//  RichTextFontReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 extended rich text font reading capabilities.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextFontReader: RichTextAttributeReader {}

extension NSAttributedString: RichTextFontReader {}

public extension RichTextFontReader {

    /**
     Get the font at a certain `range`.

     - Parameters:
       - range: The range to get the font from.
     */
    func font(at range: NSRange) -> FontRepresentable? {
        richTextAttribute(.font, at: range)
    }
}
