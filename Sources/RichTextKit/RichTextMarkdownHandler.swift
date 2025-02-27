//
// RichTextMarkdownHandler.swift
// RichTextKit
//

import Foundation
import AppKit

public extension RichTextView {

    func handleMarkdownInput() {
        print("handleMarkdownInput invoked. Current text storage: \(textStorage?.string ?? "nil")")
        guard let textStorage = self.textStorage else { return }
        let fullText = textStorage.string
        let selectedRange = self.selectedRange()
        
        // Handle headings
        handleHeadingMarkdown(fullText: fullText, selectedRange: selectedRange)
        
        // Handle bold, italic, underline
        handleInlineMarkdown(fullText: fullText, selectedRange: selectedRange)
    }

    private func handleHeadingMarkdown(fullText: String, selectedRange: NSRange) {
        // Modified patterns to work in the middle of sentences
        // (?<=^|\s) is a positive lookbehind that matches if preceded by start of line or whitespace
        let patterns = ["(?<=^|\\s)(###)\\s", "(?<=^|\\s)(##)\\s", "(?<=^|\\s)(#)\\s"]
        
        for (index, pattern) in patterns.enumerated() {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines),
               let match = regex.firstMatch(in: fullText, options: [], range: NSRange(location: 0, length: fullText.utf16.count)) {
                let nsRange = match.range(at: 0)
                let hashRange = match.range(at: 1)
                
                // Only replace the # characters and the space after them, not any preceding whitespace
                textStorage?.replaceCharacters(in: NSRange(location: hashRange.location, length: nsRange.length - (hashRange.location - nsRange.location)), with: "")
                
                // Apply heading formatting
                setTypingAttributes(forHeadingLevel: 3 - index)
                break
            }
        }
    }

    private func handleInlineMarkdown(fullText: String, selectedRange: NSRange) {
        print("Checking inline markdown in text: \(fullText)")
        let patterns = ["\\*\\*(.+?)\\*\\*", "(?<!\\*)\\*(?!\\*)(.+?)(?<!\\*)\\*(?!\\*)", "_(.+?)_"]

        for (index, pattern) in patterns.enumerated() {
            print("Inline markdown pattern checked: \(pattern)")
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            regex?.enumerateMatches(in: fullText, options: [], range: NSRange(location: 0, length: fullText.utf16.count)) { match, _, _ in
                guard let match = match, match.numberOfRanges > 1 else { return }
                print("Inline markdown pattern matched: \(pattern)")
                let markdownRange = match.range(at: 0)
                let contentRange = match.range(at: 1)
                let content = (fullText as NSString).substring(with: contentRange)

                let currentFont = textStorage?.attribute(.font, at: markdownRange.location, effectiveRange: nil) as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)

                var newFont: NSFont = currentFont
                var attributes: [NSAttributedString.Key: Any] = [:]

                switch index {
                case 0:
                    newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .boldFontMask)
                    attributes[.font] = newFont
                case 1:
                    newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .italicFontMask)
                    attributes[.font] = newFont
                case 2:
                    attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                default: break
                }

                textStorage?.replaceCharacters(in: markdownRange, with: content)
                textStorage?.addAttributes(attributes, range: NSRange(location: markdownRange.location, length: content.count))

                // Don't update the UI state when applying markdown formatting
                // This prevents the FormattingStyleToggleGroup from being updated
                // switch index {
                // case 0: formattingStateDidChange?(.bold)
                // case 1: formattingStateDidChange?(.italic)
                // case 2: formattingStateDidChange?(.underlined)
                // default: break
                // }
            }
        }
    }

    private func setTypingAttributes(forHeadingLevel level: Int) {
        let headerLevel = RichTextHeaderLevel(level)
        typingAttributes[.font] = NSFont(name: headerLevel.font.fontName, size: headerLevel.fontSize)
        
        // Store the header level in the typing attributes to ensure it's preserved
        typingAttributes[.headerLevel] = level
    }
}
