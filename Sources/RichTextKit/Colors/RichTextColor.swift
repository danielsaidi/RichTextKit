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
}

public extension RichTextColor {

    /// The unique ID of the alignment.
    var id: String { rawValue }
    
    /// The standard icon to use for the alignment.
    var icon: Image {
        switch self {
        case .foreground: return .richTextColorForeground
        case .background: return .richTextColorBackground
        case .strikethrough: return .richTextColorStrikethrough
        case .stroke: return .richTextColorStroke
        }
    }
}
