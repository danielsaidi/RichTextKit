//
//  RichTextStyleWriter.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 rich text style writing capabilities.

 This protocol is implemented by `NSMutableAttributedString`
 as well as other library types.
 */
public protocol RichTextStyleWriter: RichTextStyleReader, RichTextFontWriter {}

extension NSMutableAttributedString: RichTextStyleWriter {}

public extension RichTextStyleWriter {

    /**
     Set a certain rich text style at a certain range.

     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.

     - Parameters:
       - style: The style to set.
       - newValue: The new value to set the attribute to.
       - range: The range for which to set the attribute.
     */
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool,
        at range: NSRange
    ) {
        let range = safeRange(for: range)
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
        setFont(to: newFontValue, at: range)
    }
}
