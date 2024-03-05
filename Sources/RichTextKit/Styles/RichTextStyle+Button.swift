//
//  RichTextStyle+Button.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextStyle {

    /**
     This button can be used to toggle a ``RichTextStyle``.

     This view renders a plain `Button`, which means you can
     use and configure with plain SwiftUI.
     */
    struct Button: View {

        /**
         Create a rich text style button.

         - Parameters:
           - style: The style to toggle.
           - value: The value to bind to.
           - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
         */
        public init(
            style: RichTextStyle,
            value: Binding<Bool>,
            fillVertically: Bool = false
        ) {
            self.style = style
            self.value = value
            self.fillVertically = fillVertically
        }

        /**
         Create a rich text style button.

         - Parameters:
           - style: The style to toggle.
           - context: The context to affect.
           - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
         */
        public init(
            style: RichTextStyle,
            context: RichTextContext,
            fillVertically: Bool = false
        ) {
            self.init(
                style: style,
                value: context.binding(for: style),
                fillVertically: fillVertically
            )
        }

        private let style: RichTextStyle
        private let value: Binding<Bool>
        private let fillVertically: Bool

        public var body: some View {
            SwiftUI.Button(action: toggle) {
                style.label
                    .labelStyle(.iconOnly)
                    .frame(maxHeight: fillVertically ? .infinity : nil)
                    .contentShape(Rectangle())
            }
            .tint(.accentColor, if: isOn)
            .foreground(.accentColor, if: isOn)
            .keyboardShortcut(for: style)
            .accessibilityLabel(style.title)
        }
    }
}

extension View {

    @ViewBuilder
    func foreground(_ color: Color, if isOn: Bool) -> some View {
        if isOn {
            self.foregroundStyle(color)
        } else {
            self
        }
    }

    @ViewBuilder
    func tint(_ color: Color, if isOn: Bool) -> some View {
        if isOn {
            self.tint(color)
        } else {
            self
        }
    }
}

private extension RichTextStyle.Button {

    var isOn: Bool {
        value.wrappedValue
    }

    func toggle() {
        value.wrappedValue.toggle()
    }
}

#Preview {

    struct Preview: View {

        private let context = RichTextContext()
        @State
        private var isBoldOn = false

        @State
        private var isItalicOn = true

        @State
        private var isStrikethroughOn = false

        @State
        private var isUnderlinedOn = false

        var body: some View {
            HStack {
                Text(isBoldOn.description)

                RichTextStyle.Button(
                    style: .bold,
                    value: $isBoldOn
                )
                RichTextStyle.Button(
                    style: .italic,
                    value: $isItalicOn
                )
                RichTextStyle.Button(
                    style: .strikethrough,
                    value: $isStrikethroughOn
                )
                RichTextStyle.Button(
                    style: .underlined,
                    value: $isUnderlinedOn
                )
                .buttonStyle(.bordered)
            }
            .padding()
            .foregroundColor(.red)
        }
    }

    return Preview()
}
