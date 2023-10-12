import SwiftUI

@available(*, deprecated, message: "RichTextColorPickerColor is no longer used.")
public enum RichTextColorPickerColor: String, CaseIterable, Codable, Equatable, Identifiable {

    case black
    case gray
    case white

    case blue
    case brown
    case cyan
    case green
    case indigo
    case mint
    case orange
    case pink
    case purple
    case red
    case teal
    case yellow
}

@available(*, deprecated, message: "RichTextColorPickerColor is no longer used.")
public extension RichTextColorPickerColor {

    /// The unique ID of the color.
    var id: String { rawValue }

    /// The name of the color.
    var name: String { rawValue }

    /// The SwiftUI color that the color represents, if any.
    ///
    /// This returns `nil` if the operating system has a too
    /// low version number.
    var color: Color? {
        switch self {
        case .black: return .black
        case .gray: return .gray
        case .white: return .white

        case .blue: return .blue
        case .brown: return .brown
        case .cyan: return .cyan
        case .green: return .green
        case .indigo: return .indigo
        case .mint: return .mint
        case .orange: return .orange
        case .pink: return .pink
        case .purple: return .purple
        case .red: return .red
        case .teal: return .teal
        case .yellow: return .yellow
        }
    }

    /// Whether or not the color is available for the system.
    var isAvailable: Bool {
        color != nil
    }

    /// Get a curated list of picker colors.
    static var curated: [Self] {
        [
            .black, .gray, .white,
            .red, .pink, .orange, .yellow,
            .indigo, .purple, .blue, .cyan, .teal, .mint,
            .green, .brown
        ]
    }

    /// Get a random picker color.
    static var random: Self? {
        allCases.randomElement()
    }
}

@available(*, deprecated, message: "RichTextColorPickerColor is no longer used.")
public extension Collection where Element == RichTextColorPickerColor {

    /// Get all available SwiftUI colors from the collection.
    var colors: [Color] {
        compactMap { $0.color }
    }

    /// Get a curated list of picker colors.
    static var curated: [RichTextColorPickerColor] {
        RichTextColorPickerColor.curated
    }
}
