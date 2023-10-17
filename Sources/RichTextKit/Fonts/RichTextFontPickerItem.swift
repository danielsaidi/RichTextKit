//
//  RichTextFontPickerItem.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This internal struct is used within the custom font pickers.
 */
struct RichTextFontPickerItem: View, ListPickerItem {

    init(
        font: RichTextFontPickerFont,
        fontSize: CGFloat = 20,
        isSelected: Bool
    ) {
        self.font = font
        self.fontSize = fontSize
        self.isSelected = isSelected
    }

    typealias Item = RichTextFontPickerFont
    
    let font: RichTextFontPickerFont
    let fontSize: CGFloat
    let isSelected: Bool

    var item: RichTextFontPickerFont { font }
    
    var body: some View {
        HStack {
            Text(font.fontDisplayName)
                .font(.custom(font.fontName, size: fontSize))
            Spacer()
            if isSelected {
                checkmark
            }
        }.contentShape(Rectangle())
    }
}
