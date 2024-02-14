//
//  RichTextColor.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum defines supported rich text color types.

 The enum makes the colors identifiable and diffable.
 */
public enum RichTextColor: String, CaseIterable, Codable, Equatable, Identifiable {

    /// Foreground color.
    case foreground

    /// Background color.
    case background

    /// Strikethrough color.
    case strikethrough

    /// Stroke color.
    case stroke

    /// Underline color.
    case underline
}

public extension RichTextColor {

    /// The unique color ID.
    var id: String { rawValue }

    /// The corresponding rich text attribute, if any.
    var attribute: NSAttributedString.Key? {
        switch self {
        case .foreground: .foregroundColor
        case .background: .backgroundColor
        case .strikethrough: .strikethroughColor
        case .stroke: .strokeColor
        case .underline: .underlineColor
        }
    }

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

    /// Adjust a `color` for a certain `colorScheme`.
    func adjust(
        _ color: Color?,
        for scheme: ColorScheme
    ) -> Color {
        switch self {
        case .background: color ?? .clear
        default: color ?? .primary
        }
    }
}

public extension Collection where Element == RichTextColor {

    static var allCases: [RichTextColor] { Element.allCases }
}
