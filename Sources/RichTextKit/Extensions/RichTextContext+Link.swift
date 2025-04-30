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
        let attributes = attributedString.attributes(at: range.location, effectiveRange: nil)
        return attributes[.link] != nil
    }
    
    /// Add a link to the currently selected text
    /// - Parameters:
    ///   - urlString: The URL string to link to
    ///   - text: Optional text to replace the selection with. If nil, uses existing selection
    public func setLink(url urlString: String, text: String? = nil) {
        let range = selectedRange
//        guard range.length > 0 else { return }
        
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
        
        // Create a mutable copy of the current attributed string
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        
        // Replace the text first if needed
        mutableString.replaceCharacters(in: range, with: linkText)
        
        // Add the link attribute
        mutableString.addAttribute(.link, value: linkURL, range: linkRange)
        
        // Update the context with the new string
        actionPublisher.send(.setAttributedString(mutableString))
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