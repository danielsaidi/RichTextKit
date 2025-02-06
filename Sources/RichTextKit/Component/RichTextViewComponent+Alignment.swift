//
//  RichTextViewComponent+Alignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the text alignment.
    var richTextAlignment: RichTextAlignment? {
        guard let style = richTextParagraphStyle else { return nil }
        return RichTextAlignment(style.alignment)
    }

    /// Set the text alignment.
    func setRichTextAlignment(_ alignment: RichTextAlignment) {
        guard let text = mutableRichText else { return }
        if richTextAlignment == alignment { return }
        
        // Get the full selected range
        let selectedRange = self.selectedRange
        
        // Store the current state for undo
        let currentAttributes = NSAttributedString(attributedString: text.attributedSubstring(from: selectedRange))
        
        // Create paragraph style with the alignment
        let paragraphStyle = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            alignment: alignment
        )
        
        // Begin batch editing
        text.beginEditing()
        
        // Get the string for range calculations
        let nsString = text.string as NSString
        
        // Find paragraph ranges in the selection
        var paragraphRange = NSRange(location: selectedRange.location, length: 0)
        var remainingRange = selectedRange
        
        while remainingRange.length > 0 {
            // Get the paragraph range containing the current location
            paragraphRange = nsString.paragraphRange(for: NSRange(location: remainingRange.location, length: 0))
            
            // If paragraph extends beyond selection, trim it
            let intersectionRange = NSIntersectionRange(paragraphRange, selectedRange)
            
            // Apply paragraph style to the paragraph
            text.addAttribute(.paragraphStyle, value: paragraphStyle, range: intersectionRange)
            
            // Move to next paragraph
            let paragraphEnd = paragraphRange.location + paragraphRange.length
            let searchLocation = paragraphEnd
            
            // Update remaining range
            let remainingLength = max(0, selectedRange.location + selectedRange.length - searchLocation)
            remainingRange = NSRange(location: searchLocation, length: remainingLength)
        }
        if selectedRange.length == 0 {
            typingAttributes[.paragraphStyle] = paragraphStyle
        }

        // End batch editing
        text.endEditing()
        
        // Register undo operation
        #if canImport(UIKit)
        let undoManager = (self as? UITextView)?.undoManager
        #elseif canImport(AppKit)
        let undoManager = (self as? NSTextView)?.undoManager
        #endif
        
        undoManager?.registerUndo(withTarget: self) { target in
            target.mutableRichText?.replaceCharacters(in: selectedRange, with: currentAttributes)
        }
        undoManager?.setActionName(alignment.title)
    }
}
