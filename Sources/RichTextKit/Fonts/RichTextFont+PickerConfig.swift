//
//  RichTextFont+PickerConfig.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /// This type can configure a ``RichTextFont/Picker``.
    ///
    /// This configuration contains configuration properties
    /// for many different font pickers types. Some of these
    /// properties are not used in some pickers.
    struct PickerConfig {

        /// Create a custom font picker config.
        ///
        /// - Parameters:
        ///   - fonts: The fonts to display in the list, by default `all`.
        ///   - fontSize: The font size to use in the list items, by default `20`.
        ///   - dismissAfterPick: Whether or not to dismiss the picker after a font is selected, by default `false`.
        ///   - moveSelectionTopmost: Whether or not to place the selected font topmost, by default `true`.
        public init(
            fonts: [RichTextFont.PickerFont] = .all,
            fontSize: CGFloat = 20,
            dismissAfterPick: Bool = false,
            moveSelectionTopmost: Bool = true
        ) {
            self.fonts = fonts
            self.fontSize = fontSize
            self.dismissAfterPick = dismissAfterPick
            self.moveSelectionTopmost = moveSelectionTopmost
        }

        public typealias Font = RichTextFont.PickerFont
        public typealias FontName = String

        /// The fonts to display in the list.
        public var fonts: [RichTextFont.PickerFont]

        /// The font size to use in the list items.
        public var fontSize: CGFloat

        /// Whether or not to dismiss the picker after a font is selected.
        public var dismissAfterPick: Bool

        /// Whether or not to move the selected font topmost
        public var moveSelectionTopmost: Bool
    }
}

public extension RichTextFont.PickerConfig {

    /// The standard font picker configuration.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}

public extension RichTextFont.PickerConfig {

    /// The fonts to list for a given selection.
    func fontsToList(for selection: FontName) -> [Font] {
        if moveSelectionTopmost {
            return fonts.moveTopmost(selection)
        } else {
            return fonts
        }
    }
}

public extension View {

    /// Apply a ``RichTextFont`` picker configuration.
    func richTextFontPickerConfig(
        _ config: RichTextFont.PickerConfig
    ) -> some View {
        self.environment(\.richTextFontPickerConfig, config)
    }
}

private extension RichTextFont.PickerConfig {

    struct Key: EnvironmentKey {

        public static var defaultValue: RichTextFont.PickerConfig = .standard
    }
}

public extension EnvironmentValues {

    /// This value can bind to a font picker config.
    var richTextFontPickerConfig: RichTextFont.PickerConfig {
        get { self [RichTextFont.PickerConfig.Key.self] }
        set { self [RichTextFont.PickerConfig.Key.self] = newValue }
    }
}
