//
//  FontForEachPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view uses a plain `ForEach` to list the provided fonts,
 of which one can be selected.

 Unlike the ``FontPicker`` this picker will render the fonts
 correctly on all platforms. However, unlike regular SwiftUI
 `Picker` views, it must be presented manually, for instance
 with a sheet or a full screen cover.

 This picker also gives you full control over how the picker
 items are presented, but you have to do more yourself, like
 wrapping the picker in a `List` or a `ScrollView`. Consider
 using a ``FontPicker`` or a ``FontListPicker`` if you think
 that this is too much work.
 */
public struct FontForEachPicker: View {
    
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
        fonts: [FontPickerFont] = .all,
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
        
        ForEachPicker(
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

struct FontForEachPicker_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State private var font = ""
        
        var body: some View {
            NavigationView {
                List {
                    FontForEachPicker(
                        selection: $font)
                }
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
