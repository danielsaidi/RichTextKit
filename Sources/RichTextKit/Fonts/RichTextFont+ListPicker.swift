//
//  RichTextFont+ListPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /**
     This view uses a `List` to list a set of fonts of which
     one can be selected.
     
     Unlike ``RichTextFont/Picker`` this picker presents all
     pickers with proper previews on all platforms. You must
     therefore add it ina  way that gives it space.
     
     You can configure this picker by applying a config view
     modifier to your view hierarchy:
     
     ```swift
     VStack {
        RichTextFont.ListPicker(...)
        ...
     }
     .richTextFontPickerConfig(...)
     ```
     */
    struct ListPicker: View {

        /**
         Create a font list picker.

         - Parameters:
           - selection: The selected font name.
         */
        public init(
            selection: Binding<FontName>,
            selectionTopmost: Bool = false,
            fonts: [Font]? = nil,
            fontSize: CGFloat = 20,
            dismissAfterPick: Bool = true
        ) {
            self._selection = selection
            self.fonts = .all
            self.fonts = config.fonts
            if config.moveSelectionTopmost {
                self.fonts = config.fonts.moveTopmost(selection.wrappedValue)
            }
        }

        public typealias Font = RichTextFont.PickerFont
        public typealias FontName = String

        private var fonts: [Font]

        @Binding
        private var selection: FontName
        
        @Environment(\.richTextFontPickerConfig)
        private var config

        public var body: some View {
            let font = Binding(
                get: { Font(fontName: selection) },
                set: { selection = $0.fontName }
            )

            RichTextKit.ListPicker(
                items: fonts,
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

struct RichTextFont_ListPicker_Previews: PreviewProvider {

    struct Preview: View {

        @State private var font = ""

        var body: some View {
            NavigationView {
                RichTextFont.ListPicker(
                    selection: $font
                )
                .withTitle("Pick a font")
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}

private extension View {

    @ViewBuilder
    func withTitle(_ title: String) -> some View {
        #if iOS || os(tvOS) || os(watchOS) || os(visionOS)
        self.navigationBarTitle(title)
        #else
        self
        #endif
    }
}
