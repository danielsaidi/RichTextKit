//
//  RichTextStyleButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This button can be used to toggle a ``RichTextStyle`` value.

 This view renders a plain `Button`, which means you can use
 and configure it in all ways supported by SwiftUI. The only
 exception is the content color, which is set by a style you
 can provide in the initializer.

 If you want a more prominent button, you may consider using
 a ``RichTextStyleToggle`` instead, but it requires a higher
 deployment target.
 */
public struct RichTextStyleButton: View {

    /**
     Create a rich text style button.

     - Parameters:
       - style: The style to toggle.
       - buttonStyle: The button style to use, by default ``RichTextStyleButton/Style/standard``.
       - value: The value to bind to.
       - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
     */
    public init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        value: Binding<Bool>,
        fillVertically: Bool = false
    ) {
        self.style = style
        self.buttonStyle = buttonStyle
        self.value = value
        self.fillVertically = fillVertically
    }

    /**
     Create a rich text style button.

     - Parameters:
       - style: The style to toggle.
       - buttonStyle: The button style to use, by default ``RichTextStyleButton/Style/standard``.
       - context: The context to affect.
       - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
     */
    public init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        context: RichTextContext,
        fillVertically: Bool = false
    ) {
        self.init(
            style: style,
            buttonStyle: buttonStyle,
            value: context.binding(for: style),
            fillVertically: fillVertically
        )
    }

    private let style: RichTextStyle
    private let buttonStyle: Style
    private let value: Binding<Bool>
    private let fillVertically: Bool

    public var body: some View {
        Button(action: toggle) {
            style.icon
                .frame(maxHeight: fillVertically ? .infinity : nil)
                .foregroundColor(tintColor)
                .contentShape(Rectangle())
        }
        .keyboardShortcut(for: style)
        .accessibilityLabel(style.title)
    }
}

public extension RichTextStyleButton {

    /**
     This style can be used to style a ``RichTextStyleButton``.
     */
    struct Style {

        /**
         Create a rich text style button style.

         - Parameters:
           - inactiveColor: The color to apply when the button is inactive, by default `.primary`.
           - activeColor: The color to apply when the button is active, by default `.blue`.
         */
        public init(
            inactiveColor: Color = .primary,
            activeColor: Color = .blue
        ) {
            self.inactiveColor = inactiveColor
            self.activeColor = activeColor
        }

        /// The color to apply when the button is inactive.
        public var inactiveColor: Color

        /// The color to apply when the button is active.
        public var activeColor: Color
    }
}

public extension RichTextStyleButton.Style {

    /**
     The standard ``RichTextStyleButton`` style.
     */
    static var standard = RichTextStyleButton.Style()
}

private extension RichTextStyleButton {

    var isOn: Bool {
        value.wrappedValue
    }

    var tintColor: Color {
        isOn ? buttonStyle.activeColor : buttonStyle.inactiveColor
    }

    func toggle() {
        value.wrappedValue.toggle()
    }
}

struct RichTextStyleButton_Previews: PreviewProvider {

    struct Preview: View {

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
                RichTextStyleButton(
                    style: .bold,
                    value: $isBoldOn)
                RichTextStyleButton(
                    style: .italic,
                    value: $isItalicOn)
                RichTextStyleButton(
                    style: .strikethrough,
                    value: $isStrikethroughOn)
                RichTextStyleButton(
                    style: .underlined,
                    value: $isUnderlinedOn)
            }.padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
