//
//  RichTextFont+ForEachPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {
    
    /**
     This view uses a plain `ForEach` to list a set of fonts,
     of which one can be selected.
     
     Unlike ``RichTextFont/Picker`` the picker renders fonts
     correctly on all platforms. However, unlike the regular
     SwiftUI `Picker`, it must actively be added & presented.
     */
    struct ForEachPicker: View {
        
        /**
         Create a font picker.
         
         - Parameters:
           - selection: The selected font name.
           - selectionTopmost: Whether or not to place the selected font topmost.
           - fonts: The fonts to display in the list, by default `all`.
           - fontSize: The font size to use in the list items.
           - dismissAfterPick: Whether or not to dismiss the picker after a font has been selected, by default `false`.
         */
        public init(
            selection: Binding<FontName>,
            selectionTopmost: Bool = true,
            fonts: [Font] = .all,
            fontSize: CGFloat = 20,
            dismissAfterPick: Bool = false
        ) {
            self._selection = selection
            self.fonts = fonts
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
            
            RichTextKit.ForEachPicker(
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

struct RichTextFont_ForEachPicker_Previews: PreviewProvider {

    struct Preview: View {

        @State 
        private var selection = ""

        var body: some View {
            NavigationView {
                List {
                    RichTextFont.ForEachPicker(
                        selection: $selection,
                        selectionTopmost: false
                    )
                }
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
