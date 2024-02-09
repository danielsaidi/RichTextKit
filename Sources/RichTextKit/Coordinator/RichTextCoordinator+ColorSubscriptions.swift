//
//  RichTextCoordinator+ColorSubscriptions.swift
//
//
//  Created by Dominik Bucher on 18.01.2024.
//

#if iOS || macOS || os(tvOS)
import Foundation

extension RichTextCoordinator {

    func setColor(_ color: RichTextColor, to val: ColorRepresentable) {
        var applyRange: NSRange? = nil
        if textView.hasSelectedRange {
            applyRange = textView.selectedRange
        }
        guard let attribute = color.attribute else { return }
        if let applyRange {
            self.textView.setRichTextColor(color, to: val, at: applyRange)
        } else {
            self.textView.setRichTextAttribute(attribute, to: val)
        }
    }
}
#endif
