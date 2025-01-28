//
//  RichTextViewComponent+HeaderLevel.swift
//
//  Created by Rizwana Desai on 05/11/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

extension RichTextViewComponent {

    var richTextHeaderLevel: RichTextHeaderLevel? {
        guard let font = richTextFont else { return nil }
        return RichTextHeaderLevel(font)
    }

    func setHeaderLevel(_ level: RichTextHeaderLevel) {
        guard let text = mutableRichText else { return }
        
        // Get the full selected range
        let selectedRange = self.selectedRange
        
        // Store the current state for undo
        let currentAttributes = NSAttributedString(attributedString: text.attributedSubstring(from: selectedRange))
        
        // Set line spacing based on header level
        let lineSpacing: CGFloat
        switch level {
        case .heading1:
            lineSpacing = 24
        case .heading2:
            lineSpacing = 20
        case .heading3:
            lineSpacing = 16
        case .paragraph:
            lineSpacing = 10
        }
        
        // Create attributes to apply
        let font = level.font
        let attributes: RichTextAttributes = [.font: font]
        
        // Create paragraph style with the specified line spacing
        let paragraphStyle = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            lineSpacing: lineSpacing
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
            
            // Apply attributes to the paragraph
            text.addAttributes(attributes, range: intersectionRange)
            text.addAttribute(.paragraphStyle, value: paragraphStyle, range: intersectionRange)
            
            // Move to next paragraph
            let paragraphEnd = paragraphRange.location + paragraphRange.length
            let searchLocation = paragraphEnd
            
            // Update remaining range
            let remainingLength = max(0, selectedRange.location + selectedRange.length - searchLocation)
            remainingRange = NSRange(location: searchLocation, length: remainingLength)
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
        undoManager?.setActionName(level.title)
    }
}
