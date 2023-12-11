//
//  RichTextViewComponent+Link.swift
//
//
//  Created by Dominik Bucher on 04.12.2023.
//

import Foundation

public extension RichTextViewComponent {
    /// Unsets the current link at the given range.
    /// This method takes the range, checks if there are any attributes for link and removes them.
    /// After that, sets default typing attributes so we can continue writing as is.
    /// Note if nothing is selected, we just set typing attributes so we can continue writing in normal pace
    func unsetLinkFromCurrentRichTextStyle() {
        if hasSelectedRange {
            let range = safeRange(for: selectedRange)
            guard let string = mutableRichText else { return }
            string.beginEditing()
            string.enumerateAttribute(.customLink, in: range, options: .init()) { _, range, _ in
                string.removeAttribute(.customLink, range: range)
                string.removeAttribute(.link, range: range)
                string.addAttribute(.foregroundColor, value: ColorRepresentable.textColor, range: range)
                string.fixAttributes(in: range)
            }
            
            string.endEditing()
            self.typingAttributes = [.font: FontRepresentable.standardRichTextFont, .foregroundColor: ColorRepresentable.textColor]
            setCurrentFont(.standardRichTextFont)
        }
    }
    
    /// Set the current value of a certain rich text style.
    func setCurrentRichTextLink(
        _ link: URL?,
        previousLink: URL?
    ) {
        let shouldAdd = link != nil && previousLink == nil
        let shouldRemove = link == nil && previousLink != nil
        guard shouldAdd || shouldRemove else { return }
        if let link {
            applyToCurrentSelection(.customLink, to: CustomLinkAttributes(link: link.absoluteString, color: linkColor))
        } else {
            unsetLinkFromCurrentRichTextStyle()
        }
    }
}
