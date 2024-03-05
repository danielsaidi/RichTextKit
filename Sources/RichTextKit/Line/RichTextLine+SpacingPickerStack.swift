//
//  RichTextLine+SpacingPickerStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextLine {

    /**
     This view uses a ``RichTextLine/SpacingPicker`` and two
     steppers to increment and a decrement the value.
     
     You can configure this picker by applying a config view
     modifier to your view hierarchy:
     
     ```swift
     VStack {
     RichTextLine.SpacingPickerStack(...)
        ...
     }
     .richTextLineSpacingPickerConfig(...)
     ```
     
     > Important: This doesn't work yet, since the rich text
     context doesn't sync with the coordinator.
     */
    struct SpacingPickerStack: View {

        /**
         Create a rich text line spacing picker stack.

         - Parameters:
           - context: The context to affect.
         */
        public init(
            context: RichTextContext
        ) {
            self._context = ObservedObject(wrappedValue: context)
        }

        private let step = 1.0

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

private extension RichTextLine.SpacingPickerStack {

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

    func stepButton(_ points: CGFloat) -> some View {
        RichTextAction.Button(
            action: .stepLineSpacing(points: points),
            context: context,
            fillVertically: true
        )
    }

    var picker: some View {
        RichTextLine.SpacingPicker(
            selection: $context.lineSpacing
        )
    }

    var stepper: some View {
        Stepper("", onIncrement: increment, onDecrement: decrement)
            .labelsHidden()
    }

    func decrement() {
        context.lineSpacing -= step
    }

    func increment() {
        context.lineSpacing += step
    }
}

#Preview {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            VStack {
                Text("Spacing: \(context.lineSpacing)")
                RichTextLine.SpacingPickerStack(context: context)
            }
            .buttonStyle(.bordered)
            .padding()
        }
    }

    return Preview()
}
#endif
