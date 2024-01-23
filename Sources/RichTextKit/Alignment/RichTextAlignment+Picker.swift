//
//  RichTextAlignment+Picker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-30.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAlignment {
 
    /**
     This picker can be used to pick a rich text alignment.

     The view returns a plain SwiftUI `Picker` view that can
     be styled and configured with plain SwiftUI.
     */
    struct Picker: View {

        /**
         Create a rich text alignment picker.

         - Parameters:
           - selection: The binding to update with the picker.
           - values: The pickable alignments, by default `.allCases`.
         */
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
            SwiftUI.Picker("", selection: $selection) {
                ForEach(RichTextAlignment.allCases) { value in
                    value.label
                        .labelStyle(.iconOnly)
                }
            }
            .labelsHidden()
            .accessibilityLabel(RTKL10n.textAlignment.text)
        }
    }
}

struct RichTextAlignment_Picker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var alignment = RichTextAlignment.left

        var body: some View {
            VStack(spacing: 10) {
                RichTextAlignment.Picker(
                    selection: $alignment,
                    values: .all
                )
                .withPreviewPickerStyles()
            }
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
