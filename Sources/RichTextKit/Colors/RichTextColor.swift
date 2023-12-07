//
//  RichTextColor.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
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

    /// An undefined color type.
    case undefined
}

public extension RichTextColor {

    /// The unique ID of the alignment.
    var id: String { rawValue }

    /// The standard icon to use for the alignment.
    var icon: Image? {
        switch self {
        case .foreground: return .richTextColorForeground
        case .background: return .richTextColorBackground
        case .strikethrough: return .richTextColorStrikethrough
        case .stroke: return .richTextColorStroke
        case .undefined: return nil
        }
    }

    /// Adjust a `color` for a certain `colorScheme`.
    func adjust(
        color: Color,
        for scheme: ColorScheme
    ) -> Color {
        switch self {
        case .background:
            if (color == .black && scheme == .dark) || (color == .white && scheme == .light) {
                return .clear
            }
            return color
        case .foreground:
            if (color == .white && scheme == .dark) || (color == .black && scheme == .light) {
                return .primary
            }
            return color
        case .strikethrough: return color
        case .stroke: return color
        case .undefined: return color
        }
    }
}
