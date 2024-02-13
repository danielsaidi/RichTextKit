//
//  RichTextViewComponent+Link.swift
//
//
//  Created by Dominik Bucher on 04.12.2023.
//

import Foundation

/// This wont do anything since `linkAttributes` are not set to nil currently.
/// Waiting for https://github.com/danielsaidi/RichTextKit/pull/142 to be merged to implement link configuration.
fileprivate let linkColor = ColorRepresentable.green

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
            string.enumerateAttribute(.richTextLink, in: range, options: .init()) { _, range, _ in
                string.removeAttribute(.richTextLink, range: range)
                string.removeAttribute(.link, range: range)
                string.addAttribute(.foregroundColor, value: ColorRepresentable.textColor, range: range)
                string.fixAttributes(in: range)
            }
            
            string.endEditing()
        }
        self.typingAttributes = [.font: FontRepresentable.standardRichTextFont, .foregroundColor: ColorRepresentable.textColor]
        setRichTextFont(.standardRichTextFont)
    }
    
    /// Set the current value of a certain rich text style.
    func setCurrentRichTextLink(_ link: URL?) {
        let shouldAdd = link != nil
        let shouldRemove = link == nil
        guard shouldAdd || shouldRemove else { return }
        if let link {
            setRichTextAttribute(.richTextLink, to: CustomLinkAttributes(link: link.absoluteString, color: linkColor))
        } else {
            unsetLinkFromCurrentRichTextStyle()
        }
    }
    }
