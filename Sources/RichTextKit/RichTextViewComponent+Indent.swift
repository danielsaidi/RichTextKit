//
//  RichTextViewComponent+Indent.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextViewComponent where Self: UITextView {
    
    /**
     Use the selected range (if any) or text position to get
     the current rich text indent.
     */
    var currentRichTextIndent: CGFloat {
        let range = selectedRange
        return attributedText.richTextIndent(at: range.location)
    }
    
    /**
     Use the selected range (if any) or text position to set
     the current rich text indent.
     
     - Parameters:
     - indent: The indent to set.
     */
    func setCurrentRichTextIndent(
        to indent: RichTextIndent
    ) {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return setTextIndentAtCurrentPosition(to: indent)
        }
        setRichTextIndent(to: indent, at: selectedRange)
    }
}

private extension RichTextViewComponent {
    
    /**
     Set the text indent at the current position.
     */
    func setTextIndentAtCurrentPosition(
        to indent: RichTextIndent
    ) {
        let style = NSMutableParagraphStyle()
        
        let indentation = max(indent == .decrease ? style.headIndent - 30.0 : style.headIndent + 30.0, 0)
        style.firstLineHeadIndent = indentation
        style.headIndent = indentation
        
        var attributes = currentRichTextAttributes
        attributes[.paragraphStyle] = style
        
        typingAttributes = attributes
        
        // Check if the current line is empty
        let selectedRange = selectedRange
        let currentIndex = selectedRange.location
        
        let string = richText.string
        let lines = string.split(separator: "\n")
        let lineIndex = lines.firstIndex { line in
            let lineStartIndex = string.distance(from: string.startIndex, to: line.startIndex)
            let lineEndIndex = lineStartIndex + line.count
            return lineStartIndex <= currentIndex && currentIndex <= lineEndIndex
        }
        
        if let lineIndex = lineIndex {
            let lineStartIndex = string.distance(from: string.startIndex, to: lines[lineIndex].startIndex)
            let lineEndIndex = lineStartIndex + lines[lineIndex].count
            
            if lineStartIndex <= currentIndex && currentIndex <= lineEndIndex {
                // Calculate the target cursor position based on the indentation level
                let targetCursorPosition = lineEndIndex + 1
                // Set the new selected range to maintain the cursor position
                setSelectedRange(NSRange(location: targetCursorPosition, length: 0))
            }
            
            // Find the index of the first non-empty line above the current line
            let nonEmptyLineIndex = findFirstNonEmptyLineIndex(lines: lines, currentIndex: currentIndex)
            if let nonEmptyLineIndex = nonEmptyLineIndex {
                // Adjust the indentation level for the previous lines
                let startIndex = lines.index(before: nonEmptyLineIndex)
                let endIndex = lines.index(before: lineIndex)
                setIndentationLevel(indent, forLines: lines[startIndex...endIndex])
            }
        }
    }
    
    /**
     Find the index of the first non-empty line above the current line.
     
     - Parameters:
     - lines: The array of lines.
     - currentIndex: The index of the current line.
     
     - Returns: The index of the first non-empty line above the current line, or `nil` if not found.
     */
    func findFirstNonEmptyLineIndex(lines: [Substring], currentIndex: Int) -> Int? {
        var index = currentIndex
        while index >= 0 {
            let line = lines[index]
            if !line.isEmpty {
                return index
            }
            index -= 1
        }
        return nil
    }
    
    /**
     Adjust the indentation level for the given lines.
     
     - Parameters:
     - indent: The indentation level to set.
     - lines: The lines to adjust the indentation for.
     */
    func setIndentationLevel(_ indent: RichTextIndent, forLines lines: ArraySlice<Substring>) {
        let attributedString = NSMutableAttributedString(attributedString: richText)
        
        let range = NSRange(location: 0, length: attributedString.length)
        
        attributedString.enumerateAttribute(.paragraphStyle, in: range, options: .longestEffectiveRangeNotRequired) { value, range, _ in
            if let style = value as? NSParagraphStyle, let mutableStyle = style.mutableCopy() as? NSMutableParagraphStyle {
                let currentIndent = mutableStyle.firstLineHeadIndent
                let indentation = max(indent == .increase ? currentIndent + 30.0 : currentIndent - 30.0, 0)
                mutableStyle.firstLineHeadIndent = indentation
                mutableStyle.headIndent = indentation
                attributedString.addAttribute(.paragraphStyle, value: mutableStyle, range: range)
            }
        }
        
        setRichText(attributedString)
    }
}
