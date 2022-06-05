//
//  FontListPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This font picker uses a plain `List` to list provided fonts,
 of which one can be selected.

 Unlike the ``FontPicker`` this picker will render the fonts
 correctly on all platforms. However, unlike regular SwiftUI
 `Picker` views, it must be presented manually, for instance
 with a sheet or a full screen cover.

 This picker also provides you with native list behavior for
 all platforms, which however may also limit you if you want
 more control over how font items are listed. Consider using
 a ``FontPicker`` for a native picker, or a ``FontListPicker``
 if you want more control over hot items are listed.
 */
public struct FontListPicker: View {
    
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
        fonts: [FontPickerFont]? = nil,
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

    public typealias FontName = String

    private var fonts: [FontPickerFont]
    private let fontSize: CGFloat
    private let dismissAfterPick: Bool
    
    @Binding
    private var selection: FontName
    
    public var body: some View {
        let font = Binding(
            get: { FontPickerFont(fontName: selection) },
            set: { selection = $0.fontName }
        )
        
        ListPicker(
            items: fonts,
            selection: font,
            dismissAfterPick: dismissAfterPick) { font, isSelected in
                FontPickerItem(
                    font: font,
                    fontSize: fontSize,
                    isSelected: isSelected)
            }
    }
}

private extension View {
    
    @ViewBuilder
    func withTitle(_ title: String) -> some View {
        #if os(iOS) || os(tvOS) || os(watchOS)
        self.navigationBarTitle(title)
        #else
        self
        #endif
    }
}

struct FontListPicker_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State private var font = ""
        
        var body: some View {
            NavigationView {
                FontListPicker(
                    selection: $font)
                .withTitle("Pick a font")
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
