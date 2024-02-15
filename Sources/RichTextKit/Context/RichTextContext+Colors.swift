//
//  RichTextContext+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {

    /// Get a binding for a certain color.
    func binding(for color: RichTextColor) -> Binding<Color> {
        Binding(
            get: { Color(self.color(for: color) ?? .clear) },
            set: { self.setColor(color, to: .init($0)) }
        )
    }

    /// Get the value for a certain color.
    func color(for color: RichTextColor) -> ColorRepresentable? {
        colors[color]
    }

    /// Set the value for a certain color.
    func setColor(
        _ color: RichTextColor,
        to val: ColorRepresentable
    ) {
        guard self.color(for: color) != val else { return }
        actionPublisher.send(.setColor(color, val))
        setColorInternal(color, to: val)
    }
}

extension RichTextContext {

    /// Set the value for a certain color, or remove it.
    func setColorInternal(
        _ color: RichTextColor,
        to val: ColorRepresentable?
    ) {
        guard let val else { return colors[color] = nil }
        colors[color] = val
    }
}
