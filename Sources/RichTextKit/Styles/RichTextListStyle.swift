import Foundation

/// This enum defines different list styles that can be applied to text.
public enum RichTextListStyle: String, CaseIterable {
    
    case none
    case ordered
    case unordered
    
    /// The marker string to use for the list style
    var marker: String {
        switch self {
        case .none: ""
        case .ordered: "1."  // This will be dynamically replaced with the correct number
        case .unordered: "•"
        }
    }
}

// MARK: - List Attributes

public extension NSAttributedString.Key {
    /// The key for storing list style information
    static let listStyle = NSAttributedString.Key("com.richtextkit.listStyle")
    /// The key for storing list item number information
    static let listItemNumber = NSAttributedString.Key("com.richtextkit.listItemNumber")
} 