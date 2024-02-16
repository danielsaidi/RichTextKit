//
//  RichTextFontSizePickerStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFont {

    /**
     This view uses a ``RichTextFont/SizePicker`` and button
     steppers to increment and a decrement the font size.
     */
    struct SizePickerStack: View {

        /**
         Create a rich text font size picker stack.

         - Parameters:
           - context: The context to affect.
           - values: The values to display, by default ``RichTextFont/SizePicker/standardValues``.
         */
        public init(
            context: RichTextContext,
            values: [CGFloat] = RichTextFont.SizePicker.standardValues
        ) {
            self._context = ObservedObject(wrappedValue: context)
            self.values = values
        }

        private let values: [CGFloat]

        private let step = 1

        @ObservedObject
        private var context: RichTextContext

        public var body: some View {
            #if iOS || os(visionOS)
            stack
                .fixedSize(horizontal: false, vertical: true)
            #else
            HStack(spacing: 3) {
                picker
                stepper
            }
            .overlay(macShortcutOverlay)
            #endif
        }
    }
}

private extension RichTextFont.SizePickerStack {

    var macShortcutOverlay: some View {
        stack
            .opacity(0)
            .allowsHitTesting(false)
    }

    var stack: some View {
        HStack(spacing: 2) {
            stepButton(-step)
            picker
            stepButton(step)
        }
    }

    func stepButton(_ points: Int) -> some View {
        RichTextAction.Button(
            action: .stepFontSize(points: points),
            context: context,
            fillVertically: true
        )
    }

    var picker: some View {
        RichTextFont.SizePicker(
            selection: $context.fontSize,
            values: values
        )
    }

    var stepper: some View {
        Stepper("", onIncrement: increment, onDecrement: decrement)
            .labelsHidden()
    }

    func decrement() {
        context.fontSize -= CGFloat(step)
    }

    func increment() {
        context.fontSize += CGFloat(step)
    }
}

struct RichTextFont_SizePickerStack_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            VStack {
                Text("Size: \(context.fontSize)")
                RichTextFont.SizePickerStack(context: context)
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
