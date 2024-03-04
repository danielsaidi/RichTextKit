//
//  RichTextFormatToolbar+Config.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormatToolbar {

    /// This struct can be used to configure a format sheet.
    struct Config {

        public init(
            alignments: [RichTextAlignment] = .all,
            colorPickers: [RichTextColor] = [.foreground],
            colorPickersDisclosed: [RichTextColor] = [],
            fontPicker: Bool = true,
            fontSizePicker: Bool = true,
            indentButtons: Bool = true,
            lineSpacingPicker: Bool = false,
            styles: [RichTextStyle] = .all,
            superscriptButtons: Bool = true
        ) {
            self.alignments = alignments
            self.colorPickers = colorPickers
            self.colorPickersDisclosed = colorPickersDisclosed
            self.fontPicker = fontPicker
            self.fontSizePicker = fontSizePicker
            self.indentButtons = indentButtons
            self.lineSpacingPicker = lineSpacingPicker
            self.styles = styles
            #if macOS
            self.superscriptButtons = superscriptButtons
            #else
            self.superscriptButtons = false
            #endif
        }

        public var alignments: [RichTextAlignment]
        public var colorPickers: [RichTextColor]
        public var colorPickersDisclosed: [RichTextColor]
        public var fontPicker: Bool
        public var fontSizePicker: Bool
        public var indentButtons: Bool
        public var lineSpacingPicker: Bool
        public var styles: [RichTextStyle]
        public var superscriptButtons: Bool
    }
}

public extension RichTextFormatToolbar.Config {

    /// The standard rich text format toolbar configuration.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}

public extension View {

    /// Apply a rich text format toolbar style.
    func richTextFormatToolbarConfig(
        _ value: RichTextFormatToolbar.Config
    ) -> some View {
        self.environment(\.richTextFormatToolbarConfig, value)
    }
}

private extension RichTextFormatToolbar.Config {

    struct Key: EnvironmentKey {

        public static let defaultValue = RichTextFormatToolbar.Config()
    }
}

public extension EnvironmentValues {

    /// This value can bind to a format toolbar config.
    var richTextFormatToolbarConfig: RichTextFormatToolbar.Config {
        get { self [RichTextFormatToolbar.Config.Key.self] }
        set { self [RichTextFormatToolbar.Config.Key.self] = newValue }
    }
}
#endif
