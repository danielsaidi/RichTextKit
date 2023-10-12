import SwiftUI

@available(*, deprecated, message: "This type is no longer used")
public enum RichTextIndent: CaseIterable, Codable, Equatable, Identifiable {
    
    /// Reduce indent space.
    case decrease
    
    /// Increase indent space.
    case increase
}

@available(*, deprecated, message: "This type is no longer used")
public extension RichTextIndent {

    /// The indent's unique ID.
    var id: UUID { UUID() }
    
    /// The indent's standard icon.
    var icon: Image {
        switch self {
        case .decrease: return .richTextIndentDecrease
        case .increase: return .richTextIndentIncrease
        }
    }
}
