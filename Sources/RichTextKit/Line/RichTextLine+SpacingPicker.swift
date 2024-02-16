//
//  RichTextLine+SpacingPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextLine {

    /**
     This picker can be used to pick a font size.

     The view returns a plain SwiftUI `Picker` view that can
     be styled and configured with plain SwiftUI.
     */
    struct SpacingPicker: View {

        /**
         Create a font size picker.

         - Parameters:
           - selection: The selected font size.
           - values: The values to display in the list.
         */
        public init(
            selection: Binding<CGFloat>,
            values: [CGFloat] = standardValues
        ) {
            self._selection = selection
            self.values = Self.values(
                for: values,
                selection: selection.wrappedValue
            )
        }

        private let values: [CGFloat]

        @Binding
        private var selection: CGFloat

        public var body: some View {
            SwiftUI.Picker("", selection: $selection) {
                ForEach(values, id: \.self) {
                    text(for: $0)
                        .tag($0)
                }
            }
            .labelsHidden()
            .accessibilityLabel(RTKL10n.fontSize.text)
        }
    }
}

public extension RichTextLine.SpacingPicker {

    /// The standard picker values.
    static var standardValues: [CGFloat] {
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    }
    
    /// Get a list of values for a certain selection.
    static func values(
        for values: [CGFloat],
        selection: CGFloat
    ) -> [CGFloat] {
        let values = values + [selection]
        return Array(Set(values)).sorted()
    }
}

private extension RichTextLine.SpacingPicker {

    func text(
        for fontSize: CGFloat
    ) -> some View {
        Text(String(format: "%.1f", fontSize))
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct RichTextFont_SpacingPicker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var selection: CGFloat = 3.0

        var body: some View {
            List {
                HStack {
                    RichTextLine.SpacingPicker(
                        selection: $selection
                    )
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
