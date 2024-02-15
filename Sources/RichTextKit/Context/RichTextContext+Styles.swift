//
//  RichTextContext+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {

    /// Get a binding for a certain style.
    func binding(for style: RichTextStyle) -> Binding<Bool> {
        Binding(
            get: { Bool(self.hasStyle(style)) },
            set: { self.set(style, to: $0) }
        )
    }

    /// Check whether or not the context has a certain style.
    func hasStyle(_ style: RichTextStyle) -> Bool {
        switch style {
        case .bold: isBold
        case .italic: isItalic
        case .underlined: isUnderlined
        case .strikethrough: isStrikethrough
        }
    }

    /// Set whether or not the context has a certain style.
    func set(
        _ style: RichTextStyle,
        to val: Bool
    ) {
        switch style {
        case .bold: userActionPublisher.send(.setStyle(.bold, val)); isBold = val
        case .italic: userActionPublisher.send(.setStyle(.italic, val)); isItalic = val
        case .underlined: userActionPublisher.send(.setStyle(.underlined, val)); isUnderlined = val
        case .strikethrough: userActionPublisher.send(.setStyle(.strikethrough, val)); isStrikethrough = val
        }
    }

    /// Toggle a certain style for the context.
    func toggle(_ style: RichTextStyle) {
        set(style, to: !hasStyle(style))
    }
}
