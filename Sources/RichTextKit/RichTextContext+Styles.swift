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
            set: { self.setStyle(style, to: $0) }
        )
    }

    /// Check whether or not the context has a certain style.
    func hasStyle(_ style: RichTextStyle) -> Bool {
        styles[style] == true
    }

    /// Set whether or not the context has a certain style.
    func setStyle(
        _ style: RichTextStyle,
        to val: Bool
    ) {
        guard styles[style] != val else { return }
        actionPublisher.send(.setStyle(style, val))
        setStyleInternal(style, to: val)
    }

    /// Toggle a certain style for the context.
    func toggleStyle(_ style: RichTextStyle) {
        setStyle(style, to: !hasStyle(style))
    }
}

extension RichTextContext {

    /// Set the value for a certain color, or remove it.
    func setStyleInternal(
        _ style: RichTextStyle,
        to val: Bool?
    ) {
        guard let val else { return styles[style] = nil }
        styles[style] = val
    }
}
