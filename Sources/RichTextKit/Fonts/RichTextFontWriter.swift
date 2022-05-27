//
//  RichTextFontWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 extended rich text font writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextFontWriter: RichTextAttributeWriter {}

extension NSMutableAttributedString: RichTextFontWriter {}

public extension RichTextFontWriter {

    /**
     Set the font at a certain `range`.

     - Parameters:
       - range: The range to get the font from.
     */
    func setFont(
        _ font: FontRepresentable,
        at range: NSRange
    ) {
        setRichTextAttribute(.font, to: font, at: range)
    }
}
