//
//  RichTextKeyboardToolbar+Style.swift
//  RichTextKit
//
//  Created by Ryan Jarvis on 2024-02-24.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/// This struct can style a ``RichTextKeyboardToolbar``.
public struct RichTextKeyboardToolbarStyle {

    /// Create a custom toolbar style
    ///
    /// - Parameters:
    ///   - toolbarHeight: The height of the toolbar, by default `50`.
    ///   - itemSpacing: The spacing between toolbar items, by default `15`.
    ///   - shadowColor: The toolbar's shadow color, by default transparent black.
    ///   - shadowRadius: The toolbar's shadow radius, by default `3`.
    public init(
        toolbarHeight: Double = 50,
        itemSpacing: Double = 15,
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: Double = 3
    ) {
        self.toolbarHeight = toolbarHeight
        self.itemSpacing = itemSpacing
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }

    /// The height of the toolbar.
    public var toolbarHeight: Double

    /// The spacing between toolbar items.
    public var itemSpacing: Double

    /// The toolbar's shadow color.
    public var shadowColor: Color

    /// The toolbar's shadow radius.
    public var shadowRadius: Double
}

public extension RichTextKeyboardToolbarStyle {

    /// The standard rich text keyboard toolbar style.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}

public extension View {

    /// Apply a ``RichTextKeyboardToolbar`` style.
    func richTextKeyboardToolbarStyle(
        _ style: RichTextKeyboardToolbarStyle
    ) -> some View {
        self.environment(\.richTextKeyboardToolbarStyle, style)
    }
}

private extension RichTextKeyboardToolbarStyle {

    struct Key: EnvironmentKey {

        static var defaultValue: RichTextKeyboardToolbarStyle = .standard
    }
}

public extension EnvironmentValues {

    /// This value can bind to a keyboard toolbar style.
    var richTextKeyboardToolbarStyle: RichTextKeyboardToolbarStyle {
        get { self [RichTextKeyboardToolbarStyle.Key.self] }
        set { self [RichTextKeyboardToolbarStyle.Key.self] = newValue }
    }
}

#endif
