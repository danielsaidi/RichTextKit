//
//  RichTextColor.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextColor {

    /// The standard icon to use for the color.
    var icon: Image {
        switch self {
        case .foreground: .richTextColorForeground
        case .background: .richTextColorBackground
        case .strikethrough: .richTextColorStrikethrough
        case .stroke: .richTextColorStroke
        case .underline: .richTextColorUnderline
        }
    }

    /// The localized color title key.
    var titleKey: RTKL10n {
        switch self {
        case .foreground: .foregroundColor
        case .background: .backgroundColor
        case .strikethrough: .strikethroughColor
        case .stroke: .strokeColor
        case .underline: .underlineColor
        }
    }
}
