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
     
     You can configure this picker by applying a config view
     modifier to your view hierarchy:
     
     ```swift
     VStack {
        RichTextLine.SpacingPicker(...)
        ...
     }
     .richTextLineSpacingPickerConfig(...)
     ```
     */
    struct SpacingPicker: View {

        /**
         Create a line spacing picker.

         - Parameters:
           - selection: The selected font size.
         */
        public init(
            selection: Binding<CGFloat>
        ) {
            self._selection = selection
        }

        @Binding
        private var selection: CGFloat
        
        @Environment(\.richTextLineSpacingPickerConfig)
        private var config

        public var body: some View {
            SwiftUI.Picker(RTKL10n.lineSpacing.text, selection: $selection) {
                ForEach(values(
                    for: config.values,
                    selection: selection
                ), id: \.self) {
                    text(for: $0)
                        .tag($0)
                }
            }
        }
    }
}

public extension RichTextLine.SpacingPicker {

    /// Get a list of values for a certain selection.
    func values(
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
        private var selection: CGFloat = 2.0

        var body: some View {
            RichTextLine.SpacingPicker(
                selection: $selection
            )
            .withPreviewPickerStyles()
            .richTextLineSpacingPickerConfig(.init(values: [1, 2, 3]))
        }
    }

    static var previews: some View {
        Preview()
    }
}
