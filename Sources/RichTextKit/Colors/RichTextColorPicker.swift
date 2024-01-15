//
//  RichTextColorPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This picker can be used to select a color.

 This picker renders an icon next to the color picker and an
 optional list of horizontally scrolling quick colors.

 The quick color list is empty by default, but you can add a
 custom set of colors, for instance `.quickPickerColors`.
 */
public struct RichTextColorPicker: View {

    /**
     Create a rich text color picker that binds to a color.

     - Parameters:
       - type: The type of color to pick, by default `.undefined`.
       - icon: The icon to show, if any, by default the `type` icon.
       - value: The value to bind to.
       - quickColors: Colors to show in the trailing list, by default no colors.
     */
    public init(
        type: RichTextColor = .undefined,
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
                quickPickerDivider
                quickPicker
            }
        }
        .labelsHidden()
    }
}

private extension RichTextColorPicker {

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

private extension RichTextColorPicker {

    @ViewBuilder
    var iconView: some View {
        if let icon {
            icon.frame(minWidth: 30)
        }
    }

    @ViewBuilder
    var picker: some View {
        #if iOS || macOS
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

    func quickPickerButton(for color: Color) -> some View {
        Button {
            value = type.adjust(color, for: colorScheme)
        } label: {
            color
        }
        .buttonStyle(ColorButtonStyle( ))
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

struct RichTextColorPicker_Previews: PreviewProvider {
    private struct RichTextColorPickerPreview: View {
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

                RichTextColorPicker(
                    type: .foreground,
                    value: $foregroundColor,
                    quickColors: [.white, .black, .red, .green, .blue]
                )
                .padding(.leading)

                RichTextColorPicker(
                    type: .background,
                    value: $backgroundColor,
                    quickColors: [.white, .black, .red, .green, .blue]
                )
                .padding(.leading)
            }
        }
    }

    static var previews: some View {
        RichTextColorPickerPreview()
    }
}
