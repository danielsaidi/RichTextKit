//
//  RichTextFontSizePickerGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This component uses a ``RichTextFontSizePicker`` and adds a
 increment and a decrement button to it.

 The stepper buttons will be plain `Button` views on iOS and
 a `Stepper` on macOS. iOS will by default apply a border to
 all buttons, but you can disable this with `bordered: false`
 in the initializer.
 */
public struct RichTextFontSizePickerGroup: View {

    /**
     Create a font size picker group.

     - Parameters:
       - selection: The selected font size.
       - bordered: Whether or not the buttons are bordered, by default `true`.
       - values: The sizes to display in the list, by default ``RichTextFontSizePicker/standardFontSizes``.
     */
    public init(
        selection: Binding<CGFloat>,
        bordered: Bool = true,
        values: [CGFloat] = RichTextFontSizePicker.standardFontSizes
    ) {
        self._selection = selection
        self.bordered = bordered
        self.values = values
    }

    private let values: [CGFloat]

    private let bordered: Bool

    @Binding
    private var selection: CGFloat

    public var body: some View {
        #if os(iOS)
        HStack(spacing: 2) {
            decrementButton
            picker
            incrementButton
        }
        .bordered(if: bordered)
        .fixedSize(horizontal: false, vertical: true)
        #else
        HStack(spacing: 3) {
            picker
            stepper
        }
        #endif
    }
}

private extension RichTextFontSizePickerGroup {

    var decrementButton: some View {
        Button(action: decrement) {
            Image.richTextFontSizeDecrement.frame(maxHeight: .infinity)
        }
    }

    var incrementButton: some View {
        Button(action: increment) {
            Image.richTextFontSizeIncrement.frame(maxHeight: .infinity)
        }
    }

    var picker: some View {
        RichTextFontSizePicker(selection: $selection, values: values)
    }

    var stepper: some View {
        Stepper("", onIncrement: increment, onDecrement: decrement)
            .labelsHidden()
    }

    func decrement() {
        selection -= 1
    }

    func increment() {
        selection += 1
    }
}

private extension View {

    @ViewBuilder
    func bordered(if condition: Bool) -> some View {
        if condition, #available(iOS 15.0, macOS 12.0, *) {
            self.buttonStyle(.bordered)
        } else {
            self
        }
    }
}

struct RichTextFontSizePickerGroup_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var selection: CGFloat = 36.0

        var body: some View {
            if #available(iOS 15.0, *) {
                RichTextFontSizePickerGroup(selection: $selection)
            } else {
                RichTextFontSizePickerGroup(selection: $selection)
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
