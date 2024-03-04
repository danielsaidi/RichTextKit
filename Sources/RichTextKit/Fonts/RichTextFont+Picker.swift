//
//  RichTextFont+Picker.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /**
     This font picker can be used to pick a font from a list,
     using ``RichTextFont/PickerFont/all`` as default fonts.

     This view uses a plain `Picker`, which renders fonts on
     macOS, but not on iOS. To render fonts correctly on all
     platforms, you can use a ``RichTextFont/ListPicker`` or
     a ``RichTextFont/ForEachPicker``.
     */
    struct Picker: View {

        /**
         Create a font picker.

         - Parameters:
           - selection: The selected font name.
           - fonts: The fonts to display in the list, by default `all`.
           - fontSize: The font size to use in the list items.
         */
        public init(
            selection: Binding<FontName>,
            fonts: [Font] = .all,
            fontSize: CGFloat = 20
        ) {
            self._selection = selection
            self.fonts = fonts
            self.itemFontSize = fontSize
            self.selectedFont = fonts.last { $0.matches(selection.wrappedValue) }
        }

        public typealias Font = RichTextFont.PickerFont
        public typealias FontName = String

        private let fonts: [Font]
        private let itemFontSize: CGFloat
        private let selectedFont: Font?

        @Binding
        private var selection: FontName

        public var body: some View {
            SwiftUI.Picker(selection: $selection) {
                ForEach(fonts) { font in
                    RichTextFont.PickerItem(
                        font: font,
                        fontSize: itemFontSize,
                        isSelected: false
                    )
                    .tag(font.tag(for: selectedFont, selectedName: selection))
                }
            } label: {
                EmptyView()
            }
        }
    }
}

private extension RichTextFont.PickerFont {

    /**
     A system font has a font name that may be resolved to a
     different name when picked. We must thus try to pattern
     match, using the currently selected font name.
     */
    func matches(_ selectedFontName: String) -> Bool {
        let system = Self.systemFontNamePrefix.lowercased()
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
    func tag(for selectedFont: Self?, selectedName: String) -> String {
        let isSelected = fontName == selectedFont?.fontName
        return isSelected ? selectedName : fontName
    }
}

struct RichTextFont_Picker_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var selection = ""

        var body: some View {
            RichTextFont.Picker(
                selection: $selection
            )
            .withPreviewPickerStyles()
        }
    }

    static var previews: some View {
        Preview()
    }
}

extension View {

    func withPreviewPickerStyles() -> some View {
        NavigationView {
            #if macOS
            Color.clear
            #endif
            ScrollView {
                VStack(spacing: 10) {
                    self.label("Default")
                    self.pickerStyle(.automatic).label(".automatic")
                    self.pickerStyle(.inline).label(".inline")
                    #if iOS || macOS
                    self.pickerStyle(.menu).label(".menu")
                    #endif
                    #if iOS
                    if #available(iOS 16.0, *) {
                        pickerStyle(.navigationLink).label(".navigationLink")
                    }
                    #endif
                    #if iOS || macOS
                    if #available(iOS 17.0, macOS 14.0, watchOS 10.0, *) {
                        pickerStyle(.palette).label(".palette")
                    }
                    #endif
                    #if iOS || macOS || os(tvOS) || os(visionOS)
                    self.pickerStyle(.segmented).label(".segmented")
                    #endif
                    #if iOS
                    pickerStyle(.wheel).label(".wheel")
                    #endif
                }
            }
        }
    }
}

private extension View {
    
    func label(_ title: String) -> some View {
        VStack {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
            self
            Divider()
        }
    }
}
