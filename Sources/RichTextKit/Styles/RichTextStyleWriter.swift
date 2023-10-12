//
//  RichTextStyleWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol extends ``RichTextFontWriter`` with rich text
 font writing functionality.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other types in the library.
 */
public protocol RichTextStyleWriter: RichTextFontWriter, RichTextStyleReader {}

extension NSMutableAttributedString: RichTextStyleWriter {}

public extension RichTextStyleWriter {

    /**
     Set a certain rich text style at a certain range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     - Parameters:
       - style: The style to set.
       - newValue: The new value to set the attribute to.
       - range: The range to affect, by default the entire text.
     */
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool,
        at range: NSRange? = nil
    ) {
        let rangeValue = range ?? richTextRange
        let range = safeRange(for: rangeValue)
        let attributeValue = newValue ? 1 : 0
        if style == .underlined { return setRichTextAttribute(.underlineStyle, to: attributeValue, at: range) }
        guard let font = font(at: range) else { return }
        let styles = richTextStyles(at: range)
        let shouldAdd = newValue && !styles.hasStyle(style)
        let shouldRemove = !newValue && styles.hasStyle(style)
        guard shouldAdd || shouldRemove else { return }
        let newFont: FontRepresentable? = FontRepresentable(
            descriptor: font.fontDescriptor.byTogglingStyle(style),
            size: font.pointSize)
        guard let newFontValue = newFont else { return }
        setFont(newFontValue, at: range)
    }
}
