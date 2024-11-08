//
//  RichTextViewComponent+HeaderLevel.swift
//
//  Created by Rizwana Desai on 05/11/24.
//

import Foundation
import AppKit

extension RichTextViewComponent {

    var richTextHeaderLevel: RichTextHeaderLevel? {
        guard let font = richTextFont else { return nil }
        return RichTextHeaderLevel(font)
    }

    // TODO: Ideally i was expecting to manage header level based on paragraph style header level, but when we re-open file in that case not getting correct header level, therefore as of now managing header level based on font size. will look into it later.
    var richTextHeaderLevelOld: RichTextHeaderLevel? {
        guard let style = richTextParagraphStyle else { return nil }
        return RichTextHeaderLevel(style.headerLevel)
    }

    func setHeaderLevel2(_ level: RichTextHeaderLevel) {
        let range = lineRange(for: selectedRange)
        guard range.length > 0 else { return }
        #if os(watchOS)
        setRichTextAttribute(.paragraphStyle, to: style, at: range)
        #else
        textStorageWrapper?.addAttribute(.paragraphStyle, value: getStyleFor(header: level), range: range)
        textStorageWrapper?.addAttribute(.font, value: level.font, range: range)
        #endif
    }

    func setHeaderLevel(_ level: RichTextHeaderLevel) {
        let attributes: RichTextAttributes = [.paragraphStyle: getStyleFor(header: level), .font: level.font]
        setRichTextAttributes(attributes)
    }

    func getStyleFor(header: RichTextHeaderLevel) -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            headerLevel: header
        )
        return style
    }
}
