//
//  RichTextCoordinator+ColorSubscriptions.swift
//
//
//  Created by Dominik Bucher on 18.01.2024.
//

#if iOS || macOS || os(tvOS)
import Foundation

extension RichTextCoordinator {
    
    func setColor(_ color: ColorRepresentable, for coloredAttribute: RichTextColor) {
        var applyRange: NSRange? = nil
        if textView.hasSelectedRange {
            applyRange = textView.selectedRange
        }
        
        guard let attribute = coloredAttribute.attribute else { return }
        
        if let applyRange {
            self.textView.setRichTextColor(coloredAttribute, to: color, at: applyRange)
        } else {
            self.textView.setRichTextAttribute(attribute, to: color)
        }
    }
}
#endif
