//
//  RichTextLayoutManager.swift
//
//
//  Created by Dominik Bucher on 01.03.2024.
//

import Foundation
import UIKit

public protocol RichTextLayoutManager {
    func lineRange(for range: NSRange) -> NSRange
    func areMultipleLinesSelected(for range: NSRange) -> Bool
}

extension NSLayoutManager: RichTextLayoutManager {
    public func lineRange(for range: NSRange) -> NSRange {
        return lineRange(at: range.location)
    }

    public func areMultipleLinesSelected(for range: NSRange) -> Bool {
        guard let selectedText = textStorage?.attributedSubstring(from: range) else { return false }
        let selectedLines = selectedText.string.components(separatedBy: .newlines)

        return selectedLines.count > 1
    }
}

extension NSTextLayoutManager: RichTextLayoutManager {
    public func lineRange(for range: NSRange) -> NSRange {
        var lineRanges: [NSRange] = []
        var accumulatedLength = 0
        
        enumerateTextLayoutFragments(from: documentRange.location, options: [.ensuresLayout, .ensuresExtraLineFragment]) { fragment in
            for line in fragment.textLineFragments {
                let adjustedLength: Int
                // Line is actually ending with newline :D
                // So we need to ensure it is not counted on the line.
                if line.attributedString.string.contains("\n") {
                    adjustedLength = max(0, line.characterRange.length - 1)
                } else {
                    adjustedLength = line.characterRange.length
                }
                let adjustedLocation = accumulatedLength + line.characterRange.location
                let lineRange = NSRange(location: adjustedLocation, length: adjustedLength)
                
                lineRanges.append(lineRange)
                accumulatedLength += lineRange.length + 1 // Start of new line.
            }
            return true
        }
        
        let rangeForWholeLine = lineRanges.first {
            $0.location <= range.location && NSMaxRange($0) >= NSMaxRange(range)
        }
        
        return rangeForWholeLine ?? NSRange()
    }

    public func areMultipleLinesSelected(for range: NSRange) -> Bool {
        var ranges: [NSTextRange] = []

        // Enumerate over text layout fragments
        enumerateTextLayoutFragments(from: documentRange.location, options: [.ensuresLayout]) { fragment in
            guard let location = Int(fragment.rangeInElement.location.description),
                  let endLocation = Int(fragment.rangeInElement.endLocation.description)
            else { return false }
            let length = endLocation - location
            let fragmentRange = NSRange(location: location, length: length)

            if NSIntersectionRange(range, fragmentRange).length > 0 {
                ranges.append(fragment.rangeInElement)
            }
            return true
        }

        return ranges.count > 1
    }
}

private extension NSLayoutManager {
    /// Get the line range at a certain text location.
    func lineRange(at location: Int) -> NSRange {

        #if os(watchOS)
        return notFoundRange
        #else
        guard let storage = textStorage else { return NSRange(location: NSNotFound, length: 0) }
        let string = storage.string as NSString
        let locationRange = NSRange(location: location, length: 0)
        let lineRange = string.lineRange(for: locationRange)
        return characterRange(forGlyphRange: lineRange, actualGlyphRange: nil)
        #endif
    }

    /// Get the line range for a certain text range.
    func lineRange(for storage: NSTextStorage, range: NSRange) -> NSRange {
        #if os(watchOS)
        return notFoundRange
        #else
        // Use the location-based logic if range is empty
        if range.length == 0 {
            return lineRange(at: range.location)
        }

        var lineRange = NSRange(location: NSNotFound, length: 0)
        enumerateLineFragments(
            forGlyphRange: range
        ) { (_, _, _, glyphRange, stop) in
            lineRange = glyphRange
            stop.pointee = true
        }
        // Convert glyph range to character range
        return characterRange(forGlyphRange: lineRange, actualGlyphRange: nil)
        #endif
    }
}
