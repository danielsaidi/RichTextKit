//
//  FontPickerItem.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This internal struct is used within the custom font pickers
 that can render fonts within the picker.
 */
struct FontPickerItem: View, ListPickerItem {

    init(
        font: FontPickerFont,
        fontSize: CGFloat = 20,
        isSelected: Bool) {
        self.font = font
        self.fontSize = fontSize
        self.isSelected = isSelected
    }

    typealias Item = FontPickerFont
    
    let font: FontPickerFont
    let fontSize: CGFloat
    let isSelected: Bool

    var item: FontPickerFont { font }
    
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
