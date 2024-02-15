//
//  RichTextViewComponent+Ranges.swift
//  RichTextKit
//
//  Created by Dominik Bucher
//

import Foundation

extension RichTextViewComponent {
    
    /// Get the line range at a certain text location.
    func lineRange(at location: Int) -> NSRange {
        guard
            let manager = layoutManagerWrapper,
            let storage = textStorageWrapper
        else { return NSRange(location: NSNotFound, length: 0) }
        let string = storage.string as NSString
        let locationRange = NSRange(location: location, length: 0)
        let lineRange = string.lineRange(for: locationRange)
        return manager.characterRange(forGlyphRange: lineRange, actualGlyphRange: nil)
    }
    
    /// Get the line range for a certain text range.
    func lineRange(for range: NSRange) -> NSRange {
        
        // Use the location-based logic if range is empty
        if range.length == 0 {
            return lineRange(at: range.location)
        }
        
        guard let manager = layoutManagerWrapper else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        var lineRange = NSRange(location: NSNotFound, length: 0)
        manager.enumerateLineFragments(
            forGlyphRange: range
        ) { (_, _, _, glyphRange, stop) in
            lineRange = glyphRange
            stop.pointee = true
        }
        
        // Convert glyph range to character range
        return manager.characterRange(forGlyphRange: lineRange, actualGlyphRange: nil)
    }
}
