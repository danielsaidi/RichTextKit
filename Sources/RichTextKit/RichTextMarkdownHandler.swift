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
        let patterns = ["^(###)\\s", "^(##)\\s", "^(#)\\s"]
        for (index, pattern) in patterns.enumerated() {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines),
               let match = regex.firstMatch(in: fullText, options: [], range: NSRange(location: 0, length: fullText.utf16.count)) {
                let nsRange = match.range(at: 0)
                textStorage?.replaceCharacters(in: nsRange, with: "")
                setTypingAttributes(forHeadingLevel: 3 - index)
                break
            }
        }
    }

    private func handleInlineMarkdown(fullText: String, selectedRange: NSRange) {
        print("Checking inline markdown in text: \(fullText)")
        let patterns = ["\\*\\*(.+?)\\*\\*", "(?<!\\*)\\*(?!\\*)(.+?)(?<!\\*)\\*(?!\\*)", "_(.+?)_"]
        let attributes: [[NSAttributedString.Key: Any]] = [
            [.font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)],
            [.font: NSFontManager.shared.convert(NSFont.systemFont(ofSize: NSFont.systemFontSize), toHaveTrait: .italicFontMask)],
            [.underlineStyle: NSUnderlineStyle.single.rawValue]
        ]

        for (index, pattern) in patterns.enumerated() {
            print("Inline markdown pattern checked: \(pattern)")
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            regex?.enumerateMatches(in: fullText, options: [], range: NSRange(location: 0, length: fullText.utf16.count)) { match, _, _ in
                guard let match = match, match.numberOfRanges > 1 else { return }
                print("Inline markdown pattern matched: \(pattern)")
                let markdownRange = match.range(at: 0)
                let contentRange = match.range(at: 1)
                let content = (fullText as NSString).substring(with: contentRange)
                
                textStorage?.replaceCharacters(in: markdownRange, with: content)
                textStorage?.addAttributes(attributes[index], range: NSRange(location: markdownRange.location, length: content.count))

                switch index {
                case 0: formattingStateDidChange?(.bold)
                case 1: formattingStateDidChange?(.italic)
                case 2: formattingStateDidChange?(.underlined)
                default: break
                }
            }
        }
    }

    private func setTypingAttributes(forHeadingLevel level: Int) {
        let headerLevel = RichTextHeaderLevel(level)
        typingAttributes[.font] = NSFont(name: headerLevel.font.fontName, size: headerLevel.fontSize)
    }
}
