#if iOS || macOS
import SwiftUI

@available(*, deprecated, renamed: "RichTextColor.Picker")
public typealias RichTextColorPicker = RichTextColor.Picker

public extension RichTextColorPicker {

    @available(*, deprecated, renamed: "init(icon:value:showIcon:quickColors:)")
    init(
        color: PickerColor,
        value: Binding<Color>,
        showIcon: Bool = true,
        quickColors: [Color] = []
    ) {
        self.init(
            icon: showIcon ? color.icon : nil,
            value: value,
            quickColors: quickColors
        )
    }

    @available(*, deprecated, renamed: "init(icon:value:showIcon:quickColors:)")
    init(
        color: PickerColor,
        value: Binding<Color>,
        showIcon: Bool = true,
        quickPickerColors: [RichTextColorPickerColor]
    ) {
        self.init(
            color: color,
            value: value,
            showIcon: showIcon,
            quickColors: quickPickerColors.colors
        )
    }

    @available(*, deprecated, renamed: "init(icon:value:showIcon:quickColors:)")
    init(
        color: PickerColor,
        context: RichTextContext,
        showIcon: Bool = true,
        quickColors: [Color] = []
    ) {
        self.init(
            color: color,
            value: {
                switch color {
                case .foreground: return context.binding(for: .foreground)
                case .background: return context.binding(for: .background)
                }
            }(),
            showIcon: showIcon,
            quickColors: quickColors
        )
    }

    @available(*, deprecated, renamed: "init(icon:value:showIcon:quickColors:)")
    init(
        color: PickerColor,
        context: RichTextContext,
        showIcon: Bool = true,
        quickPickerColors: [RichTextColorPickerColor]
    ) {
        self.init(
            color: color,
            value: {
                switch color {
                case .foreground: return context.binding(for: .foreground)
                case .background: return context.binding(for: .background)
                }
            }(),
            showIcon: showIcon,
            quickColors: quickPickerColors.colors
        )
    }
}

public extension RichTextColorPicker {

    @available(*, deprecated, message: "PickerColor is no longer used.")
    enum PickerColor: String, CaseIterable, Identifiable {
        case foreground, background

        var icon: Image {
            switch self {
            case .foreground: return Image.richTextColorForeground
            case .background: return Image.richTextColorBackground
            }
        }
    }
}

@available(*, deprecated, message: "PickerColor is no longer used.")
public extension RichTextColorPicker.PickerColor {

    /// All available picker colors.
    static var all: [Self] { allCases }

    /// The color's unique identifier.
    var id: String { rawValue }

    /// The color's localized name.
    var localizedName: String {
        switch self {
        case .foreground: return RTKL10n.foregroundColor.text
        case .background: return RTKL10n.backgroundColor.text
        }
    }
}

@available(*, deprecated, message: "PickerColor is no longer used.")
public extension Collection where Element == RichTextColorPicker.PickerColor {

    /// All available picker colors.
    static var all: [RichTextColorPicker.PickerColor] { RichTextColorPicker.PickerColor.allCases }
}
#endif
