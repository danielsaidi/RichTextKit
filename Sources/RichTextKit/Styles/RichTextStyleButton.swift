//
//  RichTextStyleButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-04.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This button can be used to toggle ``RichTextStyle``s on and
 off and will use the .accent color when the style is active.

 You can apply any button styles to this button. However, if
 it isn't prominent enough, consider using a `Toggle` with a
 button style instead.
 */
public struct RichTextStyleButton: View {

    /**
     Create a rich text style button.

     - Parameters:
       - style: The style to toggle.
       - value: The value to bind to.
     */
    public init(
        style: RichTextStyle,
        value: Binding<Bool>) {
        self.style = style
        self.value = value
    }

    private let style: RichTextStyle
    private let value: Binding<Bool>

    public var body: some View {
        Button(action: toggle) {
            style.icon
                .foregroundColor(value.wrappedValue ? .accentColor : .primary)
                .contentShape(Rectangle())
        }
    }
}

private extension RichTextStyleButton {

    func toggle() {
        value.wrappedValue.toggle()
    }
}

private extension View {

    @ViewBuilder
    func withWidth(shareAvailableWidth: Bool) -> some View {
        if shareAvailableWidth {
            self.frame(maxWidth: .infinity)
        } else {
            self
        }
    }
}

struct RichTextStyleButton_Previews: PreviewProvider {

    struct Preview: View {

        @State private var isOn = false

        var body: some View {
            RichTextStyleButton(
                style: .underlined,
                value: $isOn)
        }
    }

    static var previews: some View {
        Preview()
    }
}
