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
    
    /// Add a link to the currently selected text
    /// - Parameters:
    ///   - urlString: The URL string to link to
    ///   - text: Optional text to replace the selection with. If nil, uses existing selection
    ///   - color: The color to use for the link. If nil, uses system default
    public func addLink(url urlString: String, text: String? = nil, color: Any? = nil) {
        let range = selectedRange
        guard range.length > 0 else { return }
        
        // Process URL string
        var finalURLString = urlString
        if !urlString.lowercased().hasPrefix("http://") && !urlString.lowercased().hasPrefix("https://") {
            finalURLString = "https://" + urlString
        }
        
        guard let linkURL = URL(string: finalURLString) else { return }
        
        let linkText = text ?? attributedString.string.substring(with: range)
        
        // Create a mutable copy of the current attributed string
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        
        // Get existing attributes at the selection
        let existingAttributes = mutableString.attributes(at: range.location, effectiveRange: nil)
        
        // Merge existing attributes with link attributes
        var newAttributes = existingAttributes
        newAttributes[.link] = linkURL
        
        // Set the foreground color if provided
        if let nsColor = color as? NSColor {
            newAttributes[.foregroundColor] = nsColor
        }
        
        // Replace the text while preserving other attributes
        mutableString.replaceCharacters(in: range, with: linkText)
        mutableString.setAttributes(newAttributes, range: NSRange(location: range.location, length: linkText.count))
        
        // Update the context with the new string
        setAttributedString(to: mutableString)
    }
    
    /// Check if the current selection has a link
    public var hasLink: Bool {
        let range = selectedRange
        guard range.length > 0 else { return false }
        let attributes = attributedString.attributes(at: range.location, effectiveRange: nil)
        return attributes[.link] != nil
    }
    
    /// Remove link from the current selection
    public func removeLink() {
        let range = selectedRange
        guard range.length > 0 else { return }
        
        // Create a mutable copy of the current attributed string
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        
        // Get existing attributes and remove link
        var attributes = mutableString.attributes(at: range.location, effectiveRange: nil)
        attributes.removeValue(forKey: .link)
        attributes.removeValue(forKey: .foregroundColor)  // Remove the link color
        attributes.removeValue(forKey: .underlineStyle)   // Remove the underline
        
        // Apply the updated attributes
        mutableString.setAttributes(attributes, range: range)
        
        // Update the context with the new string
        setAttributedString(to: mutableString)
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
