//
//  RichTextFontSizePickerStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
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
       - context: The context to affect.
       - values: The sizes to display in the list, by default ``RichTextFontSizePicker/standardFontSizes``.
     */
    public init(
        context: RichTextContext,
        values: [CGFloat] = RichTextFontSizePicker.standardFontSizes
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.values = values
    }

    private let values: [CGFloat]

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        #if os(iOS)
        HStack(spacing: 2) {
            decreaseButton
            picker
            increaseButton
        }
        .fixedSize(horizontal: false, vertical: true)
        #else
        HStack(spacing: 3) {
            picker
            stepper
        }.overlay(macShortcutOverlay)
        #endif
    }
}

private extension RichTextFontSizePickerStack {

    var macShortcutOverlay: some View {
        HStack {
            decreaseButton
            increaseButton
        }
        .opacity(0)
        .allowsHitTesting(false)
    }

    var decreaseButton: some View {
        RichTextActionButton(
            action: .decreaseFontSize,
            context: context,
            fillVertically: true
        )
    }

    var increaseButton: some View {
        RichTextActionButton(
            action: .increaseFontSize,
            context: context,
            fillVertically: true
        )
    }

    var picker: some View {
        RichTextFontSizePicker(
            selection: $context.fontSize,
            values: values
        )
    }

    var stepper: some View {
        Stepper("", onIncrement: increment, onDecrement: decrement)
            .labelsHidden()
    }

    func decrement() {
        context.fontSize -= 1
    }

    func increment() {
        context.fontSize += 1
    }
}

struct RichTextFontSizePickerStack_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            VStack {
                Text("Size: \(context.fontSize)")
                RichTextFontSizePickerStack(context: context)
            }
            .buttonStyle(.bordered)
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
