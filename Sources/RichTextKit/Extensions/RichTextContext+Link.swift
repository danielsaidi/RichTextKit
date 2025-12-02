import Foundation
#if canImport(AppKit)
import AppKit
#endif

public extension RichTextContext {
    
    /// Get the currently selected text, if any
    public var selectedText: String? {
        let range = selectedRange
        guard range.length > 0 else { return nil }
        return attributedString.string.substring(with: range)
    }
    
    /// Check if the current selection has a link
    public var hasLink: Bool {
        let range = selectedRange
        guard range.length > 0 else { return false }
        
        // Check if any part of the selection has a link
        var hasAnyLink = false
        var hasNoLink = false
        
        attributedString.enumerateAttributes(in: range, options: []) { attributes, _, _ in
            if attributes[.link] != nil {
                hasAnyLink = true
            } else {
                hasNoLink = true
            }
        }
        
        // Only return true if the entire selection has a link
        return hasAnyLink && !hasNoLink
    }
    
    /// Add a link to the currently selected text
    /// - Parameters:
    ///   - urlString: The URL string to link to
    ///   - text: Optional text to replace the selection with. If nil, uses existing selection
    public func setLink(url urlString: String, text: String? = nil) {
        let range = selectedRange
        
        // Only apply changes if explicitly requested and different from current
        if hasLink { return }
        
        // Process URL string
        var finalURLString = urlString
        if !urlString.lowercased().hasPrefix("http://") && !urlString.lowercased().hasPrefix("https://") {
            finalURLString = "https://" + urlString
        }
        
        guard let linkURL = URL(string: finalURLString) else { return }
        
        let linkText = text ?? attributedString.string.substring(with: range)
        let linkRange = NSRange(location: range.location, length: linkText.count)
        
        // If there's replacement text, replace it first
        if text != nil {
            let mutableString = NSMutableAttributedString(attributedString: attributedString)
            mutableString.replaceCharacters(in: range, with: linkText)
            actionPublisher.send(.setAttributedString(mutableString))
        }
        
        // Set the link attribute
        actionPublisher.send(.setLinkAttribute(linkURL, linkRange))
    }
    
    /// Remove link from the current selection
    public func removeLink() {
        let range = selectedRange
        guard range.length > 0 else { return }
        
        // Only apply changes if explicitly requested and different from current
        if !hasLink { return }
        
        // Create a mutable copy of the current attributed string
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        
        // Remove only the link attribute
        mutableString.removeAttribute(.link, range: range)
        
        // Update the context with the new string
        actionPublisher.send(.setAttributedString(mutableString))
    }
}

private extension String {
    func substring(with range: NSRange) -> String {
        guard range.location >= 0,
              range.length >= 0,
              range.location + range.length <= self.count else {
            return ""
        }
        let start = index(startIndex, offsetBy: range.location)
        let end = index(start, offsetBy: range.length)
        return String(self[start..<end])
    }
} 