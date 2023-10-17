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
       - icon: The icon to show, if any.
       - value: The value to bind to.
       - quickColors: Colors to show in the trailing list, by default `empty`.
     */
    public init(
        icon: Image?,
        value: Binding<Color>,
        quickColors: [Color] = []
    ) {
        self.icon = icon
        self.value = value
        self.quickColors = quickColors
    }

    private let icon: Image?
    private let value: Binding<Color>
    private let quickColors: [Color]

    private let spacing = 10.0

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
        #if os(iOS) || os(macOS)
        ColorPicker("", selection: value)
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
            value.wrappedValue = color
        } label: {
            color
        }
        .buttonStyle(ColorButtonStyle(isSelected: isSelected(color)))
        .animation(.default, value: value.wrappedValue)
    }

    var quickPickerDivider: some View {
        Divider()
            .padding(0)
            .frame(maxHeight: 30)
    }
}

private struct ColorButtonStyle: ButtonStyle {
    
    let isSelected: Bool
    
    @Environment(\.isFocused)
    var isFocused: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        let focusSize: Double = isFocused ? 25 : 20
        let size: Double = isSelected ? 30 : focusSize
        return configuration.label
            .frame(width: size, height: size)
            .clipShape(Circle())
            .shadow(radius: 1, x: 0, y: 1)
            .padding(.vertical, isSelected ? 0 : 5)
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

struct RichTextColorPicker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var text = Color.black

        @State
        private var background = Color.white

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                RichTextColorPicker(
                    icon: .richTextColorBackground,
                    value: $text
                )
                RichTextColorPicker(
                    icon: .richTextColorForeground,
                    value: $background,
                    quickColors: [.red, .green, .blue]
                )
            }.padding(.leading)
        }
    }

    static var previews: some View {
        Preview()
    }
}
