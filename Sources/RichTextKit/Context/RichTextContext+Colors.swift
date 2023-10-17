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
        case .foreground: return foregroundColor
        case .background: return backgroundColor
        case .strikethrough: return strikethroughColor
        case .stroke: return strokeColor
        }
    }
    
    /// Set the value for a certain color.
    func setColor(
        _ color: ColorRepresentable,
        for val: RichTextColor
    ) {
        if self.color(for: val) == color { return }
        switch val {
        case .foreground: foregroundColor = color
        case .background: backgroundColor = color
        case .strikethrough: strikethroughColor = color
        case .stroke: strokeColor = color
        }
    }
}
