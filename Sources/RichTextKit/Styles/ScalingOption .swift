//
//  ScalingOption.swift
//  RichTextKit
//
//  Created by Rizwana Desai on 03/03/25.
//

import Foundation

public enum FontScalingOption: String, CaseIterable, Identifiable {
    case defaultFont
    case extraSmall
    case small
    case large
    case extraLarge
    public var id: FontScalingOption { self }

    public var value: String {
        switch self {
        case .defaultFont:
            "Default"
        case .extraSmall:
            "Extra Small"
        case .small:
            "Small"
        case .large:
            "Large"
        case .extraLarge:
            "Extra large"
        }
    }

    public var factor: CGFloat {
        switch self {
        case .defaultFont:
            1
        case .extraSmall:
            0.6
        case .small:
            0.8
        case .large:
            1.2
        case .extraLarge:
            1.4
        }
    }
}
