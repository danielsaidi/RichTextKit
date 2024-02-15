//
//  RichTextFont+PickerItem.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

extension RichTextFont {
    
    /**
     This struct is used by the various library font pickers.
     */
    struct PickerItem: View, ListPickerItem {

        init(
            font: Item,
            fontSize: CGFloat = 20,
            isSelected: Bool
        ) {
            self.font = font
            self.fontSize = fontSize
            self.isSelected = isSelected
        }

        typealias Item = RichTextFont.PickerFont

        let font: Item
        let fontSize: CGFloat
        let isSelected: Bool

        var item: Item { font }

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
}
