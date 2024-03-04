//
//  RichTextFont+SizePicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /**
     This picker can be used to pick a font size.

     The view returns a plain SwiftUI `Picker` view that can
     be styled and configured with plain SwiftUI.
     
     You can configure this picker by applying a config view
     modifier to your view hierarchy:
     
     ```swift
     VStack {
        RichTextFont.SizePicker(...)
        ...
     }
     .richTextFontSizePickerConfig(...)
     ```
     */
    struct SizePicker: View {

        /**
         Create a font size picker.

         - Parameters:
           - selection: The selected font size.
         */
        public init(
            selection: Binding<CGFloat>
        ) {
            self._selection = selection
            self.values = []
            self.values = Self.values(
                for: config.values,
                selection: selection.wrappedValue
            )
        }

        private var values: [CGFloat]

        @Binding
        private var selection: CGFloat
        
        @Environment(\.richTextFontSizePickerConfig)
        private var config

        public var body: some View {
            SwiftUI.Picker(RTKL10n.fontSize.text, selection: $selection) {
                ForEach(values, id: \.self) {
                    text(for: $0)
                        .tag($0)
                }
            }
        }
    }
}

public extension RichTextFont.SizePicker {

    /// Get a list of values for a certain selection.
    static func values(
        for values: [CGFloat],
        selection: CGFloat
    ) -> [CGFloat] {
        let values = values + [selection]
        return Array(Set(values)).sorted()
    }
}

private extension RichTextFont.SizePicker {

    func text(
        for fontSize: CGFloat
    ) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct RichTextFont_SizePicker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var selection: CGFloat = 36.0

        var body: some View {
            RichTextFont.SizePicker(
                selection: $selection
            )
            .withPreviewPickerStyles()
        }
    }

    static var previews: some View {
        Preview()
    }
}
