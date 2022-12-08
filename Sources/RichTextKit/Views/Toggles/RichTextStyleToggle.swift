//
//  RichTextStyleToggle.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This button can be used to toggle a ``RichTextStyle`` value.

 This renders a plain `Button`, which means that you can use
 and configure it as normal. The only exception is the color
 of the content, which is determined by the button style you
 can provide in the initializer.

 If you want a more prominent button, you may consider using
 the ``RichTextStyleToggle`` instead.
 */
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 9.0, *)
public struct RichTextStyleToggle: View {

    /**
     Create a rich text style button.

     - Parameters:
       - style: The style to toggle.
       - buttonStyle: The button style to use, by default ``RichTextStyleToggle/Style/standard``.
       - value: The value to bind to.
     */
    public init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        value: Binding<Bool>
    ) {
        self.style = style
        self.buttonStyle = buttonStyle
        self.value = value
    }

    /**
     Create a rich text style button.

     - Parameters:
       - style: The style to toggle.
       - buttonStyle: The button style to use, by default ``RichTextStyleToggle/Style/standard``.
       - context: The context to affect.
     */
    public init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        context: RichTextContext
    ) {
        self.style = style
        self.buttonStyle = buttonStyle
        switch style {
        case .bold: self.value = context.isBoldBinding
        case .italic: self.value = context.isItalicBinding
        case .underlined: self.value = context.isUnderlinedBinding
        }
    }

    private let style: RichTextStyle
    private let buttonStyle: Style
    private let value: Binding<Bool>

    public var body: some View {
        #if os(tvOS)
        toggle
        #else
        toggle.toggleStyle(.button)
        #endif
    }

    private var toggle: some View {
        Toggle(isOn: value) {
            style.icon
        }.tint(tintColor)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 9.0, *)
public extension RichTextStyleToggle {

    /**
     This style can be used to style a ``RichTextStyleToggle``.
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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 9.0, *)
public extension RichTextStyleToggle.Style {

    /**
     The standard ``RichTextStyleToggle`` style.
     */
    static var standard = RichTextStyleToggle.Style()
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 9.0, *)
private extension RichTextStyleToggle {

    var isOn: Bool {
        value.wrappedValue
    }

    var tintColor: Color {
        isOn ? buttonStyle.activeColor : buttonStyle.inactiveColor
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 9.0, *)
struct RichTextStyleToggle_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var isBoldOn = false

        @State
        private var isItalicOn = true

        @State
        private var isUnderlinedOn = false

        var body: some View {
            HStack {
                RichTextStyleToggle(
                    style: .bold,
                    value: $isBoldOn)
                RichTextStyleToggle(
                    style: .italic,
                    value: $isItalicOn)
                RichTextStyleToggle(
                    style: .underlined,
                    value: $isUnderlinedOn)
            }.padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
