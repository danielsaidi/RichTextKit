//
//  RichTextColorPickerStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This view can be used to list a collection of pickers for a
 set of colors in a horizontal line.

 Since this view controls multiple values, it binds directly
 to a ``RichTextContext`` instead of individual values.
 */
public struct RichTextColorPickerStack: View {

    /**
     Create a rich text color picker stack.

     - Parameters:
       - context: The context to affect.
       - colors: The colors to list, by default ``RichTextColorPicker/PickerColor/all``.
       - spacing: The spacing to apply to stack items, by default `20`.
     */
    public init(
        context: RichTextContext,
        colors: [RichTextColorPicker.PickerColor] = .all,
        spacing: Double = 20
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.colors = colors
        self.spacing = spacing
    }

    private let colors: [RichTextColorPicker.PickerColor]
    private let spacing: Double

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(colors) {
                RichTextColorPicker(color: $0, context: context)
            }
        }
    }
}

struct RichTextColorPickerStack_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextColorPickerStack(context: context)
                .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
