//
//  RichTextFont+ForEachPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /**
     This view uses a plain `ForEach` to list a set of fonts,
     of which one can be selected.

     Unlike ``RichTextFont/Picker`` this picker presents all
     pickers with proper previews on all platforms. You must
     therefore add it ina  way that gives it space.
     
     You can configure this picker by applying a config view
     modifier to your view hierarchy:
     
     ```swift
     VStack {
        RichTextFont.ForEachPicker(...)
        ...
     }
     .richTextFontPickerConfig(...)
     ```
     */
    struct ForEachPicker: View {

        /**
         Create a font picker.

         - Parameters:
           - selection: The selected font name.
         */
        public init(
            selection: Binding<FontName>
        ) {
            self._selection = selection
        }

        public typealias Config = RichTextFont.PickerConfig
        public typealias Font = Config.Font
        public typealias FontName = Config.FontName

        @Binding
        private var selection: FontName
        
        @Environment(\.richTextFontPickerConfig)
        private var config

        public var body: some View {
            let font = Binding(
                get: { Font(fontName: selection) },
                set: { selection = $0.fontName }
            )

            RichTextKit.ForEachPicker(
                items: config.fontsToList(for: selection),
                selection: font,
                dismissAfterPick: config.dismissAfterPick
            ) { font, isSelected in
                RichTextFont.PickerItem(
                    font: font,
                    fontSize: config.fontSize,
                    isSelected: isSelected
                )
            }
        }
    }
}

#Preview {

    struct Preview: View {

        @State
        private var selection = ""

        var body: some View {
            NavigationView {
                #if macOS
                Color.clear
                #endif
                List {
                    RichTextFont.ForEachPicker(
                        selection: $selection
                    )
                }
                .navigationTitle("Pick a font")
            }
            .richTextFontPickerConfig(.init(moveSelectionTopmost: true))
        }
    }

    return Preview()
}
