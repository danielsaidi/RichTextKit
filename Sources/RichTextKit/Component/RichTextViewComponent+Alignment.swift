//
//  RichTextViewComponent+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the rich text alignment at current range.
    var richTextAlignment: RichTextAlignment? {
        guard let style = richTextParagraphStyle else { return nil }
        return RichTextAlignment(style.alignment)
    }

    /// Set the rich text alignment at current range.
    ///
    /// > Todo: Something's currently off with alignment. It
    /// spills over to other paragraphs when moving the input
    /// cursor and inserting new text.
    func setRichTextAlignment(
        _ alignment: RichTextAlignment
    ) {
        if richTextAlignment == alignment { return }
        setAlignment(alignment.nativeAlignment)
    }
    
    #if macOS
    private func setAlignment(_ alignment: NSTextAlignment) {
        guard let hey = (self as? NSTextView), let textStorage = hey.textStorage, let layoutManager = hey.layoutManager else {
            return
        }
        
        var lineRange = NSRange(location: NSNotFound, length: 0)
        
        // If there is a selection, find the entire line range based on the selected range
        if selectedRange.length > 0 {
            lineRange = lineRangeForSelectedRange(selectedRange)
        } else {
            // If no selection, find the line range for the current cursor position
            let cursorLocation = selectedRange.location
            lineRange = lineRangeForCursorLocation(cursorLocation)
        }
        
        if lineRange.length > 0 {
            // Change alignment for the entire line
            textStorage.addAttribute(.paragraphStyle, value: createParagraphStyle(alignment: alignment), range: lineRange)
        }
    }
    
    private func lineRangeForCursorLocation(_ cursorLocation: Int) -> NSRange {
        guard let hey = (self as? NSTextView), let textStorage = hey.textStorage, let layoutManager = hey.layoutManager else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        let lineRange = (textStorage.string as NSString).lineRange(for: NSRange(location: cursorLocation, length: 0))
        
        // Convert line range to character range
        return layoutManager.characterRange(forGlyphRange: lineRange, actualGlyphRange: nil)
    }
    
    private func lineRangeForSelectedRange(_ selectedRange: NSRange) -> NSRange {
        guard let hey = (self as? NSTextView), let textStorage = hey.textStorage, let layoutManager = hey.layoutManager else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        var lineRange = NSRange(location: NSNotFound, length: 0)
        layoutManager.enumerateLineFragments(forGlyphRange: selectedRange) { (rect, usedRect, textContainer, glyphRange, stop) in
            lineRange = glyphRange
            stop.pointee = true
        }
        
        // Convert glyph range to character range
        return layoutManager.characterRange(forGlyphRange: lineRange, actualGlyphRange: nil) 
    }
    
    
    private func createParagraphStyle(alignment: NSTextAlignment) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return paragraphStyle
    }
    #else
    
    private func setTypingAttributesAlignment(_ alignment: RichTextAlignment) {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment.nativeAlignment
        var attributes = richTextAttributes
        attributes[.paragraphStyle] = style
        typingAttributes = attributes
    }
    
    private func setAlignment(_ alignment: NSTextAlignment) {
        guard let hey = (self as? UITextView) else {
            return
        }
        
        var lineRange = NSRange(location: NSNotFound, length: 0)
        
        // If there is a selection, find the entire line range based on the selected range
        if selectedRange.length > 0 {
            lineRange = lineRangeForSelectedRange(selectedRange)
        } else {
            // If no selection, find the line range for the current cursor position
            let cursorLocation = selectedRange.location
            lineRange = lineRangeForCursorLocation(cursorLocation)
        }
        
        if lineRange.length > 0 {
            // Change alignment for the entire line
            hey.textStorage.addAttribute(.paragraphStyle, value: createParagraphStyle(alignment: alignment), range: lineRange)
        }
    }
    
    private func lineRangeForCursorLocation(_ cursorLocation: Int) -> NSRange {
        guard let hey = (self as? UITextView) else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        let lineRange = (hey.textStorage.string as NSString).lineRange(for: NSRange(location: cursorLocation, length: 0))
        
        // Convert line range to character range
        return hey.layoutManager.characterRange(forGlyphRange: lineRange, actualGlyphRange: nil)
    }
    
    private func lineRangeForSelectedRange(_ selectedRange: NSRange) -> NSRange {
        guard let hey = (self as? UITextView) else {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        var lineRange = NSRange(location: NSNotFound, length: 0)
        hey.layoutManager.enumerateLineFragments(forGlyphRange: selectedRange) { (rect, usedRect, textContainer, glyphRange, stop) in
            lineRange = glyphRange
            stop.pointee = true
        }
        
        // Convert glyph range to character range
        return hey.layoutManager.characterRange(forGlyphRange: lineRange, actualGlyphRange: nil)
    }
    
    
    private func createParagraphStyle(alignment: NSTextAlignment) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return paragraphStyle
    }
    #endif
}
