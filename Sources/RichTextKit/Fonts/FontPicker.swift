//
//  FontPicker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This font picker uses a plain `Picker` to list the provided
 fonts, of which one can be selected.

 Since this view uses a plain `Picker`, you can apply any of
 the native picker styles to this picker as well.
 
 Note that some platforms don't render custom fonts for some
 picker styles. For these situations, you can use the custom
 ``FontListPicker`` and ``FontForEachPicker`` pickers, which
 give you more control over how fonts are rendered.
 */
public struct FontPicker: View {
    
    /**
     Create a font picker.
     
     - Parameters:
       - selection: The selected font name.
       - fonts: The fonts to display in the list, by default `all`.
       - fontSize: The font size to use in the list items.
     */
    public init(
        selection: Binding<FontName>,
        fonts: [FontPickerFont] = .all,
        fontSize: CGFloat = 20) {
        self._selection = selection
        self.fonts = fonts
        self.itemFontSize = fontSize
        self.selectedFont = fonts.last { $0.matches(selection.wrappedValue) }
    }

    public typealias FontName = String
    
    private let fonts: [FontPickerFont]
    private let itemFontSize: CGFloat
    private let selectedFont: FontPickerFont?
    
    @Binding
    private var selection: FontName
    
    public var body: some View {
        Picker(selection: $selection) {
            ForEach(fonts) { font in
                FontPickerItem(
                    font: font,
                    fontSize: itemFontSize,
                    isSelected: false)
                .tag(font.tag(for: selectedFont, selectedName: selection))
            }
        } label: {
            EmptyView()
        }
    }
}

private extension FontPickerFont {
    
    /**
     A system font has a font name that may be resolved to a
     different font name when it's picked. We must therefore
     do our best to pattern match the available fonts to the
     currently selected font name.
     */
    func matches(_ selectedFontName: String) -> Bool {
        let system = FontPickerFont.systemFontNamePrefix.lowercased()
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
    func tag(for selectedFont: FontPickerFont?, selectedName: String) -> String {
        let isSelected = fontName == selectedFont?.fontName
        return isSelected ? selectedName : fontName
    }
}

struct FontPicker_Previews: PreviewProvider {
    
    struct Preview: View {
        
        @State private var selectedFontName = ""
        
        var body: some View {
            NavigationView {
                FontPicker(selection: $selectedFontName)
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
        if #available(iOS 14.0, macOS 12.0, *) {
            self.pickerStyle(.menu)
        } else {
            self
        }
        #else
        self
        #endif
    }
}
