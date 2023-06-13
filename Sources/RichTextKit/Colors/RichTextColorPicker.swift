//
//  RichTextColorPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This button can be used to select a certain color value. It
 renders an appropriate icon next to the color picker and an
 optional list of horizontally scrolling quick colors.

 The quick color list is empty by default, but you provide a
 custom collection or colors, or use any `quickPickerColors`
 initializer and e.g. pass in `.curated`.
 */
public struct RichTextColorPicker: View {

    /**
     Create a rich text color picker that binds to a color.

     - Parameters:
       - color: The color to pick.
       - value: The value to bind to.
       - showIcon: Whether or not to show the icon, by default `true`.
       - quickColors: Colors to show in the trailing list, by default none.
     */
    public init(
        color: PickerColor,
        value: Binding<Color>,
        showIcon: Bool = true,
        quickColors: [Color] = []
    ) {
        self.color = color
        self.value = value
        self.showIcon = showIcon
        self.quickColors = quickColors
    }

    /**
     Create a rich text color picker that binds to a color.

     - Parameters:
       - color: The color to pick.
       - value: The value to bind to.
       - showIcon: Whether or not to show the icon, by default `true`.
       - quickColors: Colors to show in the trailing list, by default none.
     */
    public init(
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

    /**
     Create a rich text color picker that binds to a context.

     - Parameters:
       - color: The color to pick.
       - context: The context to affect.
       - showIcon: Whether or not to show the icon, by default `true`.
       - quickColors: Colors to show in the trailing list, by default none.
     */
    public init(
        color: PickerColor,
        context: RichTextContext,
        showIcon: Bool = true,
        quickColors: [Color] = []
    ) {
        self.init(
            color: color,
            value: {
                switch color {
                case .foreground: return context.foregroundColorBinding
                case .background: return context.backgroundColorBinding
                }
            }(),
            showIcon: showIcon,
            quickColors: quickColors
        )
    }

    /**
     Create a rich text color picker that binds to a context.

     - Parameters:
       - color: The color to pick.
       - context: The context to affect.
       - showIcon: Whether or not to show the icon, by default `true`.
       - quickColors: Colors to show in the trailing list, by default none.
     */
    public init(
        color: PickerColor,
        context: RichTextContext,
        showIcon: Bool = true,
        quickPickerColors: [RichTextColorPickerColor]
    ) {
        self.init(
            color: color,
            value: {
                switch color {
                case .foreground: return context.foregroundColorBinding
                case .background: return context.backgroundColorBinding
                }
            }(),
            showIcon: showIcon,
            quickColors: quickPickerColors.colors
        )
    }

    private let color: PickerColor
    private let value: Binding<Color>
    private let showIcon: Bool
    private let quickColors: [Color]

    private let spacing = 10.0

    public var body: some View {
        HStack(spacing: 0) {
            icon
            picker
            if !quickColors.isEmpty {
                quickPickerDivider
                quickPicker
            }
        }
        .labelsHidden()
    }
}

private extension RichTextColorPicker {

    @ViewBuilder
    var icon: some View {
        if showIcon {
            color.icon
                .frame(minWidth: 30)
        }
    }

    var picker: some View {
        ColorPicker("", selection: value)
            .fixedSize()
            .padding(.horizontal, spacing)
    }

    var quickPicker: some View {
        ScrollView(.horizontal) {
            HStack(spacing: spacing) {
                ForEach(Array(quickColors.enumerated()), id: \.offset) {
                    quickPickerButton(for: $0.element)
                }
            }
            .padding(.horizontal, spacing)
        }.frame(maxWidth: .infinity)
    }

    func quickPickerButton(for color: Color) -> some View {
        Button {
            value.wrappedValue = color
        } label: {
            let size: Double = isSelected(color) ? 30 : 20
            Circle()
                .fill(color)
                .shadow(radius: 1, x: 0, y: 1)
                .frame(width: size, height: size)
                .padding(.vertical, isSelected(color) ? 0 : 10)
                .animation(.default, value: value.wrappedValue)
        }.buttonStyle(.plain)
    }

    var quickPickerDivider: some View {
        Divider()
            .padding(0)
            .frame(maxHeight: 30)
    }
}

private extension RichTextColorPicker {

    func isSelected(_ color: Color) -> Bool {
        value.wrappedValue == color
    }

    func select(color: Color) {
        value.wrappedValue = color
    }
}

public extension RichTextColorPicker {

    /**
     This enum specifies which colors this picker can pick.
     */
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

public extension Collection where Element == RichTextColorPicker.PickerColor {

    /// All available picker colors.
    static var all: [RichTextColorPicker.PickerColor] { RichTextColorPicker.PickerColor.allCases }
}

struct RichTextColorPicker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var text = Color.black

        @State
        private var background = Color.white

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                RichTextColorPicker(
                    color: .foreground,
                    value: $text
                )
                RichTextColorPicker(
                    color: .background,
                    value: $background,
                    quickColors: [.red, .green, .blue]
                )
                RichTextColorPicker(
                    color: .background,
                    value: $background,
                    quickPickerColors: .curated
                ).background(Color.red)
            }.padding(.leading)
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
