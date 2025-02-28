//
// RichTextMarkdownHandler.swift
// RichTextKit
//

import Foundation
import AppKit

public extension RichTextView {

    func handleMarkdownInput() {
        guard let textStorage = self.textStorage else { return }
        let fullText = textStorage.string
        let selectedRange = self.selectedRange()

        if let coordinator = self.delegate as? RichTextCoordinator {
            print("Delegate correctly cast to RichTextCoordinator")
            print("Markdown processing started - setting isApplyingMarkdown to true")
            coordinator.context.isApplyingMarkdown = true
            
            // Begin editing session
            textStorage.beginEditing()
            
            // Store the original state
            let originalText = NSAttributedString(attributedString: textStorage)
            let originalRange = selectedRange
            
            handleHeadingMarkdown(fullText: fullText, selectedRange: selectedRange)
            handleInlineMarkdown(fullText: fullText, selectedRange: selectedRange)
            
            // End editing session
            textStorage.endEditing()
            
            // Register undo for the markdown changes
            undoManager?.registerUndo(withTarget: self) { target in
                if let ts = target.textStorage {
                    ts.beginEditing()
                    ts.setAttributedString(originalText)
                    ts.endEditing()
                    target.selectedRange = originalRange
                }
            }
            
            coordinator.syncContextWithTextView()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                coordinator.context.isApplyingMarkdown = false
                print("Markdown processing ended - setting isApplyingMarkdown to false")
            }
        } else {
            print("Delegate NOT correctly cast to RichTextCoordinator")
        }
    }

    private func handleHeadingMarkdown(fullText: String, selectedRange: NSRange) {
        // Modified patterns to work in the middle of sentences
        // (?<=^|\s) is a positive lookbehind that matches if preceded by start of line or whitespace
        let patterns = ["(?<=^|\\s)(###)\\s", "(?<=^|\\s)(##)\\s", "(?<=^|\\s)(#)\\s"]
        
        for (index, pattern) in patterns.enumerated() {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines),
                  let match = regex.firstMatch(in: fullText, options: [], range: NSRange(location: 0, length: fullText.utf16.count)) else { continue }

            let nsRange = match.range(at: 0)
            let hashRange = match.range(at: 1)

            print("Detected hashtags at range: \(nsRange), hashRange: \(hashRange)")

            textStorage?.replaceCharacters(in: NSRange(location: hashRange.location, length: nsRange.length - (hashRange.location - nsRange.location)), with: "")

            if let coordinator = self.delegate as? RichTextCoordinator {
                coordinator.context.headerLevel = RichTextHeaderLevel(3 - index)
                coordinator.syncContextWithTextView()
                print("Header level explicitly set to: \(coordinator.context.headerLevel)")
            }

            break
        }
    }

    private func handleInlineMarkdown(fullText: String, selectedRange: NSRange) {
        let patterns = ["\\*\\*(.+?)\\*\\*", "(?<!\\*)\\*(?!\\*)(.+?)(?<!\\*)\\*(?!\\*)", "_(.+?)_"]
        var replacements: [(range: NSRange, content: String, attributes: [NSAttributedString.Key: Any])] = []

        for (index, pattern) in patterns.enumerated() {
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            regex?.enumerateMatches(in: fullText, options: [], range: NSRange(location: 0, length: fullText.utf16.count)) { match, _, _ in
                guard let match = match, match.numberOfRanges > 1 else { return }
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

                replacements.append((markdownRange, content, attributes))
            }
        }

        // Apply all replacements in reverse order to maintain correct ranges
        for replacement in replacements.reversed() {
            textStorage?.replaceCharacters(in: replacement.range, with: replacement.content)
            textStorage?.addAttributes(replacement.attributes, range: NSRange(location: replacement.range.location, length: replacement.content.count))
        }
    }

    private func setTypingAttributes(forHeadingLevel level: Int) {
        let headerLevel = RichTextHeaderLevel(level)
        typingAttributes[.font] = NSFont(name: headerLevel.font.fontName, size: headerLevel.fontSize)
        
        // Store the header level in the typing attributes to ensure it's preserved
        typingAttributes[.headerLevel] = level
    }
}
