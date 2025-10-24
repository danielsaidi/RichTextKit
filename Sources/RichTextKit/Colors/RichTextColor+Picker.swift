//
//  RichTextColor+Picker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextColor {

    /// This picker can be used to select a rich text color.
    ///
    /// This picker renders an icon next to the color picker as well as an optional
    /// list of custom quick colors.
    struct Picker: View {

        /// Create a rich text color picker.
        ///
        /// - Parameters:
        ///   - type: The type of color to pick.
        ///   - icon: The icon to show, if any, by default the `type` icon.
        ///   - value: The value to bind to.
        ///   - quickColors: Colors to show in the trailing list, by default no colors.
        public init(
            type: RichTextColor,
            icon: Image? = nil,
            value: Binding<Color>,
            quickColors: [Color] = []
        ) {
            self.type = type
            self.icon = icon ?? type.icon
            self._value = value
            self.quickColors = quickColors
        }

        private let type: RichTextColor
        private let icon: Image?
        private let quickColors: [Color]

        @Binding
        private var value: Color

        private let spacing = 10.0

        @Environment(\.colorScheme)
        private var colorScheme

        public var body: some View {
            HStack(spacing: 0) {
                iconView
                picker
                if hasColors {
                    HStack(spacing: spacing) {
                        quickPickerDivider
                        quickPickerButton(for: nil)
                        quickPickerDivider
                    }
                    quickPicker
                }
            }
            .labelsHidden()
        }
    }
}

private extension RichTextColor.Picker {

    var hasColors: Bool {
        !quickColors.isEmpty
    }
}

public extension Color {

    /// Get a curated list of quick color picker colors.
    static var quickPickerColors: [Self] {
        [
            .black, .gray, .white,
            .red, .pink, .orange, .yellow,
            .indigo, .purple, .blue, .cyan, .teal, .mint,
            .green, .brown
        ]
    }
}

public extension Collection where Element == Color {

    /// Get a curated list of quick color picker colors.
    static var quickPickerColors: [Element] {
        Element.quickPickerColors
    }
}

private extension RichTextColor.Picker {

    @ViewBuilder
    var iconView: some View {
        if let icon {
            icon.frame(minWidth: 30)
        }
    }

    @ViewBuilder
    var picker: some View {
        #if iOS || macOS || os(visionOS)
        ColorPicker("", selection: $value)
            .fixedSize()
            .padding(.horizontal, spacing)
        #endif
    }

    var quickPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(Array(quickColors.enumerated()), id: \.offset) {
                    quickPickerButton(for: $0.element)
                }
            }
            .padding(.horizontal, spacing)
            .padding(.vertical, 2)
        }.frame(maxWidth: .infinity)
    }

    func quickPickerButton(for color: Color?) -> some View {
        Button {
            value = type.adjust(color, for: colorScheme)
        } label: {
            if let color {
                color
            } else {
                Image.richTextColorReset
            }
        }
        .buttonStyle(ColorButtonStyle())
    }

    var quickPickerDivider: some View {
        Divider()
            .padding(0)
            .frame(maxHeight: 30)
    }
}

private struct ColorButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 20, height: 20)
            .clipShape(Circle())
            .shadow(radius: 1, x: 0, y: 1)
    }
}

#Preview {

    struct Preview: View {
        @State
        private var foregroundColor = Color.black

        @State
        private var backgroundColor = Color.white

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Preview")
                    .foregroundStyle(foregroundColor)
                    .padding()
                    .background(backgroundColor)
                    .frame(maxWidth: .infinity)
                    .border(Color.black)
                    .background(Color.red)
                    .padding()

                RichTextColor.Picker(
                    type: .foreground,
                    value: $foregroundColor,
                    quickColors: [.white, .black, .red, .green, .blue]
                )
                .padding(.leading)

                RichTextColor.Picker(
                    type: .background,
                    value: $backgroundColor,
                    quickColors: [.white, .black, .red, .green, .blue]
                )
                .padding(.leading)
            }
        }
    }

    return Preview()
}
