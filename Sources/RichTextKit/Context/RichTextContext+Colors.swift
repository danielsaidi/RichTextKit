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
    func binding(for color: RichTextColor) -> Binding<Color> {
        Binding(
            get: { Color(self.color(for: color) ?? .clear) },
            set: { self.setColor(color, to: ColorRepresentable($0)) }
        )
    }

    /// Get the value for a certain color.
    func color(for color: RichTextColor) -> ColorRepresentable? {
        switch color {
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
        _ color: RichTextColor,
        to val: ColorRepresentable
    ) {
        guard self.color(for: color) != val else { return }
        userActionPublisher.send(.setColor(color, val))

        switch color {
        case .foreground: foregroundColor = val
        case .background: backgroundColor = val
        case .strikethrough: strikethroughColor = val
        case .stroke: strokeColor = val
        case .underline: underlineColor = val
        case .undefined: return
        }
    }
}
