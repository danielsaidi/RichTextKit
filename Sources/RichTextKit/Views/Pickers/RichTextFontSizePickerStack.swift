//
//  RichTextFontSizePickerStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This view lists a ``RichTextFontSizePicker`` and buttons to
 increment and a decrement the font size.

 iOS adds plain `Button` steppers to each side of the picker
 while macOS adds a native `Stepper` after the picker.

 iOS will by default apply a border to the steppers. You can
 disable this by adding `bordered: false` to the initializer.
 */
public struct RichTextFontSizePickerStack: View {

    /**
     Create a rich text font size picker stack.

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

private extension RichTextFontSizePickerStack {

    var decrementButton: some View {
        Button(action: decrement) {
            Image.richTextFontSizeDecrement
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
        }
    }

    var incrementButton: some View {
        Button(action: increment) {
            Image.richTextFontSizeIncrement
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
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

struct RichTextFontSizePickerStack_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var selection: CGFloat = 36.0

        var body: some View {
            if #available(iOS 15.0, *) {
                RichTextFontSizePickerStack(selection: $selection)
            } else {
                RichTextFontSizePickerStack(selection: $selection)
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
