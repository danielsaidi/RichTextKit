//
//  RichTextContext+Styles.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {

    /// Get a binding for a certain color.
    func binding(for val: RichTextColor) -> Binding<Color> {
        Binding(
            get: { Color(self.color(for: val) ?? .clear) },
            set: { self.setColor(ColorRepresentable($0), for: val) }
        )
    }

    /// Get the value for a certain color.
    func color(for val: RichTextColor) -> ColorRepresentable? {
        switch val {
        case .foreground: foregroundColor
        case .background: backgroundColor
        case .strikethrough: strikethroughColor
        case .stroke: strokeColor
        case .underline: underlineColor
        case .undefined: nil
        }
    }

    /// Set the value for a certain color.
    func setColor(
        _ color: ColorRepresentable,
        for val: RichTextColor
    ) {
        guard self.color(for: val) != color else { return }
        switch val {
        case .foreground: userActionPublisher.send(.foregroundColor(color))
        case .background: userActionPublisher.send(.backgroundColor(color))
        case .strikethrough: userActionPublisher.send(.strikethroughColor(color))
        case .stroke: userActionPublisher.send(.strokeColor(color))
        case .underline: userActionPublisher.send(.underlineColor(color))
        case .undefined: return
        }
    }
}
