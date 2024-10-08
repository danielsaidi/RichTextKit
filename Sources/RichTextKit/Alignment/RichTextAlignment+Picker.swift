//
//  RichTextAlignment+Picker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAlignment {

    /// This picker can be used to pick a text alignment.
    ///
    /// This view returns a plain SwiftUI `Picker` view that
    /// can be styled and configured with a `PickerStyle`.
    struct Picker: View {

        /// Create a rich text alignment picker.
        ///
        /// - Parameters:
        ///   - selection: The binding to update with the picker.
        ///   - values: The pickable alignments, by default `.allCases`.
        public init(
            selection: Binding<RichTextAlignment>,
            values: [RichTextAlignment] = RichTextAlignment.allCases
        ) {
            self._selection = selection
            self.values = values
        }

        let values: [RichTextAlignment]

        @Binding
        private var selection: RichTextAlignment

        public var body: some View {
            SwiftUI.Picker(RTKL10n.textAlignment.text, selection: $selection) {
                ForEach(values) { value in
                    value.label
                        .labelStyle(.iconOnly)
                }
            }
        }
    }
}

#Preview {

    struct Preview: View {

        @State
        private var alignment = RichTextAlignment.left

        var body: some View {
            RichTextAlignment.Picker(
                selection: $alignment,
                values: .all
            )
            .withPreviewPickerStyles()
        }
    }

    return Preview()
}
