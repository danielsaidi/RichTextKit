//
//  RichTextViewComponent+Indent.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewComponent {

    /**
     Use the selected range (if any) or text position to get
     the current rich text alignment.
     */
    var currentRichTextIndent: RichTextIndent? {
        let attribute: NSMutableParagraphStyle? = currentRichTextAttribute(.paragraphStyle)
        guard let style = attribute else { return nil }
        return RichTextIndent(rawValue: style.headIndent)
    }

    /**
     Use the selected range (if any) or text position to set
     the current rich text alignment.

     - Parameters:
       - alignment: The alignment to set.
     */
    func setCurrentRichTextIndent(
        to indent: RichTextIndent
    ) {
        if !hasTrimmedText {
            return setTextIndentAtCurrentPosition(to: indent)
        }
        setRichTextIndent(to: indent, at: selectedRange)
    }
}

private extension RichTextViewComponent {

    /**
     Set the text indent at the current position.
     */
    func setTextIndentAtCurrentPosition(
        to indent: RichTextIndent
    ) {
        let style = NSMutableParagraphStyle()
        
        let indentation = max(indent == .decrease ? style.headIndent - 30.0 : style.headIndent + 30.0, 0)
        style.firstLineHeadIndent = indentation
        style.headIndent = indentation
        
        var attributes = currentRichTextAttributes
        attributes[.paragraphStyle] = style
        typingAttributes = attributes
    }
}
