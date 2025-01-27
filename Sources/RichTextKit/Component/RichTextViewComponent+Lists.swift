import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {
    
    /// Get the list style at the current selection or insertion point
    var richTextListStyle: RichTextListStyle {
        let attributes = richTextAttributes
        return attributes[.listStyle] as? RichTextListStyle ?? .none
    }
    
    /// Get the list item number at the current selection or insertion point
    var richTextListItemNumber: Int {
        let attributes = richTextAttributes
        return attributes[.listItemNumber] as? Int ?? 1
    }
    
    /// Set the list style for the current selection or paragraph
    func setRichTextListStyle(_ style: RichTextListStyle) {
        let range = lineRange(for: selectedRange)
        guard range.length > 0 else { return }
        
        // Get existing paragraph style or create new one
        let paragraphStyle = (richTextParagraphStyle ?? .init()).mutableCopy() as! NSMutableParagraphStyle
        
        // Configure for list
        paragraphStyle.configureForList(style)
        
        // Update paragraph style
        setRichTextParagraphStyle(paragraphStyle)
        
        // Set list attributes
        if style != .none {
            let itemNumber = findListItemNumber(for: range)
            setRichTextAttributes([
                .listStyle: style,
                .listItemNumber: itemNumber
            ], at: range)
        } else {
            // Remove list attributes
            let string = mutableRichText
            string?.removeAttribute(.listStyle, range: range)
            string?.removeAttribute(.listItemNumber, range: range)
        }
        
        // Update following list items if needed
        if style == .ordered {
            updateFollowingListItems(after: range)
        }
    }
    
    /// Find the appropriate list item number for a given range
    private func findListItemNumber(for range: NSRange) -> Int {
        let text = richText
        if text.length == 0 { return 1 }
        
        // Look backward from the current range to find the previous list item
        var itemNumber = 1
        var location = range.location
        
        while location > 0 {
            let prevRange = NSRange(location: location - 1, length: 1)
            let attributes = text.attributes(at: prevRange.location, effectiveRange: nil)
            
            if let prevStyle = attributes[.listStyle] as? RichTextListStyle,
               prevStyle == .ordered,
               let prevNumber = attributes[.listItemNumber] as? Int {
                itemNumber = prevNumber + 1
                break
            }
            
            location -= 1
        }
        
        return itemNumber
    }
    
    /// Update the item numbers of list items following the given range
    private func updateFollowingListItems(after range: NSRange) {
        guard let text = mutableRichText else { return }
        var currentNumber = richTextListItemNumber
        var currentLocation = range.location + range.length
        
        while currentLocation < text.length {
            let attributes = text.attributes(at: currentLocation, effectiveRange: nil)
            if let style = attributes[.listStyle] as? RichTextListStyle,
               style == .ordered {
                currentNumber += 1
                let itemRange = lineRange(for: NSRange(location: currentLocation, length: 0))
                setRichTextAttributes([.listItemNumber: currentNumber], at: itemRange)
                currentLocation = itemRange.location + itemRange.length
            } else {
                break
            }
        }
    }
} 