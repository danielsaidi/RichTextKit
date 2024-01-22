//
//  RichTextStyle+Toggle.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextStyle {
    
    /**
     This toggle can be used to toggle a ``RichTextStyle``.
     
     This view renders a plain `Toggle`, which means you can
     use and configure with plain SwiftUI. The one exception
     is the tint color, which is set with a style.
     
     > Note: The view uses a ``RichTextStyleButton`` if it's
     used on iOS 14, macOS 11, tvOS 14 and watchOS 8.
     */
    struct Toggle: View {
        
        /**
         Create a rich text style toggle toggle.
         
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
         Create a rich text style toggle.
         
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
            #if os(tvOS) || os(watchOS)
            toggle
            #else
            toggle.toggleStyle(.button)
            #endif
        }
        
        private var toggle: some View {
            SwiftUI.Toggle(isOn: value) {
                style.icon
                    .frame(maxHeight: fillVertically ? .infinity : nil)
            }
            .tint(tintColor)
            .keyboardShortcut(for: style)
            .accessibilityLabel(style.title)
        }
    }
}

private extension RichTextStyle.Toggle {

    var backgroundColor: Color {
        value.wrappedValue ? buttonStyle.activeColor.opacity(0.2) : .clear
    }
}

public extension RichTextStyle.Toggle {

    struct Style {

        /**
         Create a rich text style button style.

         - Parameters:
           - inactiveColor: The color to apply when the button is inactive, by default `nil`.
           - activeColor: The color to apply when the button is active, by default `.blue`.
         */
        public init(
            inactiveColor: Color? = nil,
            activeColor: Color = .blue
        ) {
            self.inactiveColor = inactiveColor
            self.activeColor = activeColor
        }

        /// The color to apply when the button is inactive.
        public var inactiveColor: Color?

        /// The color to apply when the button is active.
        public var activeColor: Color
    }
}

public extension RichTextStyle.Toggle.Style {

    /// The standard ``RichTextStyle/Toggle`` style.
    static var standard = RichTextStyle.Toggle.Style()
}

private extension RichTextStyle.Toggle {

    var isOn: Bool {
        value.wrappedValue
    }

    var tintColor: Color? {
        isOn ? buttonStyle.activeColor : buttonStyle.inactiveColor
    }
}

struct RichTextStyle_Toggle_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var isBoldOn = false

        @State
        private var isItalicOn = true

        @State
        private var isStrikethroughOn = true

        @State
        private var isUnderlinedOn = true

        var body: some View {
            HStack {
                RichTextStyle.Toggle(
                    style: .bold,
                    value: $isBoldOn)
                RichTextStyle.Toggle(
                    style: .italic,
                    value: $isItalicOn)
                RichTextStyle.Toggle(
                    style: .strikethrough,
                    value: $isStrikethroughOn)
                RichTextStyle.Toggle(
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
