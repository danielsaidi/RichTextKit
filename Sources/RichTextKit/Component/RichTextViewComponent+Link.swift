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
            richText.enumerateAttributes(in: selectedRange) { [weak self] attributes, range, _ in
                guard let self else { return }
                let mutableAttributedString = NSMutableAttributedString(attributedString: richText)
                attributes.forEach { attribute, _ in
                    mutableAttributedString.removeAttribute(attribute, range: range)
                    mutableAttributedString.fixAttributes(in: range)
                    mutableAttributedString.addAttribute(.font, value: FontRepresentable.standardRichTextFont, range: range)
                    mutableAttributedString.addAttribute(.foregroundColor, value: ColorRepresentable.textColor, range: range)
                }
                setRichText(mutableAttributedString)
            }
        }
        
        self.typingAttributes = [.font: FontRepresentable.standardRichTextFont, .foregroundColor: ColorRepresentable.textColor]
        setCurrentFont(.standardRichTextFont)
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
            setCurrentRichTextAttribute(.customLink, to: CustomLinkAttributes(link: link.absoluteString, color: linkColor))
        } else {
            unsetLinkFromCurrentRichTextStyle()
        }
    }
}
