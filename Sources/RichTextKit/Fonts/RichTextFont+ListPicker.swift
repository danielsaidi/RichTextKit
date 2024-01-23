//
//  RichTextFont+ListPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /**
     This view uses a `List` to list a set of fonts of which
     one can be selected.

     Unlike ``RichTextFont/Picker`` the picker renders fonts
     correctly on all platforms. However, unlike the regular
     SwiftUI `Picker`, it must actively be added & presented.
     */
    struct ListPicker: View {

        /**
         Create a font picker.

         - Parameters:
           - selection: The selected font name.
           - selectionTopmost: Whether or not to place the selected font topmost.
           - fonts: The fonts to display in the list, by default `all`.
           - fontSize: The font size to use in the list items.
           - dismissAfterPick: Whether or not to dismiss the picker after a font has been selected, by default `true`.
         */
        public init(
            selection: Binding<FontName>,
            selectionTopmost: Bool = false,
            fonts: [Font]? = nil,
            fontSize: CGFloat = 20,
            dismissAfterPick: Bool = true
        ) {
            self._selection = selection
            self.fonts = fonts ?? .all
            self.fontSize = fontSize
            self.dismissAfterPick = dismissAfterPick
            if selectionTopmost {
                self.fonts = self.fonts.moveTopmost(selection.wrappedValue)
            }
        }

        public typealias Font = RichTextFont.PickerFont
        public typealias FontName = String

        private var fonts: [Font]
        private let fontSize: CGFloat
        private let dismissAfterPick: Bool

        @Binding
        private var selection: FontName

        public var body: some View {
            let font = Binding(
                get: { Font(fontName: selection) },
                set: { selection = $0.fontName }
            )

            RichTextKit.ListPicker(
                items: fonts,
                selection: font,
                dismissAfterPick: dismissAfterPick
            ) { font, isSelected in
                RichTextFont.PickerItem(
                    font: font,
                    fontSize: fontSize,
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
