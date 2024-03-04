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
        var ranges: [NSTextRange] = []
        enumerateTextLayoutFragments(from: documentRange.location, options: [.ensuresLayout]) { fragment in
            ranges.append(fragment.rangeInElement)
            return true
        }
        
        var finalRange: NSRange?
        for containingRange in ranges {
            guard let start = Int(containingRange.location.description),
                  let end = Int(containingRange.endLocation.description)
            else { finalRange = NSRange(); break }
            if (start...end).contains(range.location) {
                finalRange = NSRange(location: start, length: end - start)
            }
        }
        
        print(ranges)
        return finalRange ?? NSRange()
    }

    public func areMultipleLinesSelected(for range: NSRange) -> Bool {
        var ranges: [NSTextRange] = []
        
        // Enumerate over text layout fragments
        enumerateTextLayoutFragments(from: documentRange.location, options: [.ensuresLayout]) { fragment in
            guard let location = Int(fragment.rangeInElement.location.description),
                  let endLocation = Int(fragment.rangeInElement.endLocation.description)
            else { return false }
            let lenght = endLocation - location
            let fragmentRange = NSRange(location: location, length: lenght)
            
            if NSIntersectionRange(range, fragmentRange).length > 0 {
                // If it does, add the range of the fragment to the array
                ranges.append(fragment.rangeInElement)
            }
            return true
        }
        
        // If there are more than one range in the array, it means multiple lines are selected
        return ranges.count > 1
    }
}

// Utility extension to convert NSRange to Range<String.Index> for NSTextStorage
extension NSRange {
    func toRange(in textStorage: NSTextStorage) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        let startIndex = textStorage.string.index(textStorage.string.startIndex, offsetBy: location)
        let endIndex = textStorage.string.index(startIndex, offsetBy: length)
        return startIndex..<endIndex
    }
}

extension NSLayoutManager {
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
