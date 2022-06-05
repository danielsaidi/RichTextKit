//
//  RichTextViewRepresentable+Pasting.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewRepresentable {

    /**
     Paste a text into the text view, at a certain position.

     This function does a bit of range handling to make sure
     that the context and text view is kept in sync.

     - Parameters:
       - text: The text to paste.
       - index: The index to paste the text into.
       - moveCursorToPastedText: Whether or not to move the cursor to the end of the pasted text, by default `false`.
     */
    func pasteText(
        _ text: String,
        at index: Int,
        moveCursorToPastedText: Bool = false
    ) {
        let text = NSMutableAttributedString(string: text)
        let content = NSMutableAttributedString(attributedString: attributedString)
        let font = content.font(at: selectedRange) ?? .standardRichTextFont
        let fontRange = NSRange(location: 0, length: text.length)
        text.setFont(to: font, at: fontRange)
        content.insert(text, at: index)
        setRichText(content)
        if moveCursorToPastedText {
            moveInputCursor(to: index + text.length)
        }
    }
}
