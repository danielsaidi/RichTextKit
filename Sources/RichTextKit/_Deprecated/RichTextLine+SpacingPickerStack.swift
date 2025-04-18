//
//  RichTextLine+SpacingPickerStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

@available(*, deprecated, message: "Use SwiftUI Picker with native NSParagraphStyle directly instead.")
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

        var value: Binding<CGFloat> {
            context.paragraphStyleValueBinding(for: \.lineSpacing)
        }

        public var body: some View {
            HStack(spacing: 5) {
                RichTextLine.SpacingPicker(
                    selection: value
                )
                Stepper("", value: value, step: 0.1)
                    .labelsHidden()
            }
        }
    }
}
#endif
