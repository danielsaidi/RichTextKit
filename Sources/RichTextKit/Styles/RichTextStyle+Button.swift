//
//  RichTextStyle+Button.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextStyle {
    
    /**
     This button can be used to toggle a ``RichTextStyle``.
     
     This view renders a plain `Button`, which means you can
     use and configure with plain SwiftUI. The one exception
     is the content color, which is set with a style.
     */
    struct Button: View {
        
        /**
         Create a rich text style button.
         
         - Parameters:
           - style: The style to toggle.
           - buttonStyle: The button style to use, by default `.standard`.
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
           - buttonStyle: The button style to use, by default `.standard`.
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
            SwiftUI.Button(action: toggle) {
                style.label
                    .labelStyle(.iconOnly)
                    .frame(maxHeight: fillVertically ? .infinity : nil)
                    .foregroundColor(tintColor)
                    .contentShape(Rectangle())
            }
            .keyboardShortcut(for: style)
            .accessibilityLabel(style.title)
        }
    }
}

public extension RichTextStyle.Button {

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

public extension RichTextStyle.Button.Style {

    /// The standard ``RichTextStyle/Button`` style.
    static var standard = RichTextStyle.Button.Style()
}

private extension RichTextStyle.Button {

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

struct RichTextStyle_Button_Previews: PreviewProvider {

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
                RichTextStyle.Button(
                    style: .bold,
                    value: $isBoldOn)
                RichTextStyle.Button(
                    style: .italic,
                    value: $isItalicOn)
                RichTextStyle.Button(
                    style: .strikethrough,
                    value: $isStrikethroughOn)
                RichTextStyle.Button(
                    style: .underlined,
                    value: $isUnderlinedOn)
            }
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
