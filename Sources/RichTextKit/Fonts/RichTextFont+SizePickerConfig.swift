//
//  RichTextFont+SizePickerConfig.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextFont {

    /// This type can configure a ``RichTextFont/SizePicker``.
    struct SizePickerConfig {

        /// Create a custom font size picker config.
        ///
        /// - Parameters:
        ///   - values: The values to display in the list, by default a standard list.
        public init(
            values: [CGFloat] = [10, 12, 14, 18, 20, 22, 24, 28, 36, 48, 64, 72, 96, 144]
        ) {
            self.values = values
        }

        /// The values to display in the list.
        public var values: [CGFloat]
    }
}

public extension RichTextFont.SizePickerConfig {

    /// The standard font size picker configuration.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}

public extension View {

    /// Apply a ``RichTextFont`` size picker configuration.
    func richTextFontSizePickerConfig(
        _ config: RichTextFont.SizePickerConfig
    ) -> some View {
        self.environment(\.richTextFontSizePickerConfig, config)
    }
}

private extension RichTextFont.SizePickerConfig {

    struct Key: EnvironmentKey {

        public static var defaultValue: RichTextFont.SizePickerConfig = .standard
    }
}

public extension EnvironmentValues {

    /// This value can bind to a font size picker config.
    var richTextFontSizePickerConfig: RichTextFont.SizePickerConfig {
        get { self [RichTextFont.SizePickerConfig.Key.self] }
        set { self [RichTextFont.SizePickerConfig.Key.self] = newValue }
    }
}
