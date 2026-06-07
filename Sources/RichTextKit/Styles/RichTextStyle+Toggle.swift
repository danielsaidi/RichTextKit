//
//  RichTextStyle+Toggle.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextStyle {

    /**
     This toggle can be used to toggle a ``RichTextStyle``.

     This view renders a plain `Toggle`, which means you can
     use and configure with plain SwiftUI. The one exception
     is the tint color, which is set with a style.
     */
    struct Toggle: View {

        /**
         Create a rich text style toggle toggle.

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
            self.context = nil
        }

        /**
         Create a rich text style toggle.

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
            self.style = style
            self.fillVertically = fillVertically
            self.context = context
            
            if style == .link {
                self.value = Binding(
                    get: { context.hasLink },
                    set: { _ in
                        guard context.hasSelectedRange else { return }
                        if context.hasLink {
                            context.removeLink()
                        } else {
                            context.isLinkSheetPresented = true
                        }
                    }
                )
            } else {
                self.value = context.binding(for: style)
            }
        }

        private let style: RichTextStyle
        private let value: Binding<Bool>
        private let fillVertically: Bool
        private let context: RichTextContext?

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
            .toggleStyle(.button)
            .keyboardShortcut(for: style)
            .accessibilityLabel(style.title)
        }
        

    }
}

private extension RichTextStyle.Toggle {

    var isOn: Bool {
        value.wrappedValue
    }
}

#Preview {

    struct Preview: View {

        @State
        private var isBoldOn = false

        @State
        private var isItalicOn = true

        @State
        private var isStrikethroughOn = true

        @State
        private var isUnderlinedOn = true

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            HStack {
                toggle(for: .bold, $isBoldOn)
                toggle(for: .italic, $isItalicOn)
                toggle(for: .strikethrough, $isStrikethroughOn)
                toggle(for: .underlined, $isUnderlinedOn)
                Divider()
                RichTextStyle.Toggle(
                    style: .bold,
                    context: context,
                    fillVertically: true
                )
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
        }

        func toggle(for style: RichTextStyle, _ binding: Binding<Bool>) -> some View {
            RichTextStyle.Toggle(
                style: style,
                value: binding,
                fillVertically: true
            )
        }
    }

    return Preview()
}
