//
//  RichTextFontPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This font picker can be used to pick a font from a list. It
 will by default use ``RichTextFontPickerFont/all`` fonts.

 This view renders a plain `Picker`, which means you can use
 and configure it in all ways supported by SwiftUI.

 Note that only macOS will render the fonts correctly, while
 iOS will not render the fonts and tvOS will just list every
 font in a horizontal list. On these platforms, consider the
 ``RichTextFontListPicker`` or ``RichTextFontForEachPicker``
 instead, which can be more customized.
 */
public struct RichTextFontPicker: View {
    
    /**
     Create a font picker.
     
     - Parameters:
       - selection: The selected font name.
       - fonts: The fonts to display in the list, by default `all`.
       - fontSize: The font size to use in the list items.
     */
    public init(
        selection: Binding<FontName>,
        fonts: [RichTextFontPickerFont] = .all,
        fontSize: CGFloat = 20
    ) {
        self._selection = selection
        self.fonts = fonts
        self.itemFontSize = fontSize
        self.selectedFont = fonts.last { $0.matches(selection.wrappedValue) }
    }

    public typealias FontName = String
    
    private let fonts: [RichTextFontPickerFont]
    private let itemFontSize: CGFloat
    private let selectedFont: RichTextFontPickerFont?
    
    @Binding
    private var selection: FontName
    
    public var body: some View {
        Picker(selection: $selection) {
            ForEach(fonts) { font in
                RichTextFontPickerItem(
                    font: font,
                    fontSize: itemFontSize,
                    isSelected: false
                ).tag(font.tag(for: selectedFont, selectedName: selection))
            }
        } label: {
            EmptyView()
        }
    }
}

private extension RichTextFontPickerFont {
    
    /**
     A system font has a font name that may be resolved to a
     different font name when it's picked. We must therefore
     do our best to pattern match the available fonts to the
     currently selected font name.
     */
    func matches(_ selectedFontName: String) -> Bool {
        let system = RichTextFontPickerFont.systemFontNamePrefix.lowercased()
        let selected = selectedFontName.lowercased()
        let fontName = self.fontName.lowercased()
        if fontName.isEmpty { return system == selected }
        if fontName == selected { return true }
        if selected.hasPrefix(fontName.replacingOccurrences(of: " ", with: "")) { return true }
        if selected.hasPrefix(fontName.replacingOccurrences(of: " ", with: "-")) { return true }
        return false
    }
    
    /**
     Use the selected font name as tag for the selected font.
     */
    func tag(for selectedFont: RichTextFontPickerFont?, selectedName: String) -> String {
        let isSelected = fontName == selectedFont?.fontName
        return isSelected ? selectedName : fontName
    }
}

struct FontPicker_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State
        private var selection = ""
        
        var body: some View {
            NavigationView {
                RichTextFontPicker(selection: $selection)
                    .withStyle()
                    .padding(20)
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}

private extension View {
    
    @ViewBuilder
    func withStyle() -> some View {
        #if os(iOS) || os(macOS)
        self.pickerStyle(.menu)
        #else
        self
        #endif
    }
}
