//
//  RichTextFormat+ToolbarConfig.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormat {

    /// This type can be used to configure a format toolbar.
    struct ToolbarConfig {

        public init(
            alignments: [NSTextAlignment] = .defaultPickerValues,
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

        public var alignments: [NSTextAlignment]
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

public extension RichTextFormat.ToolbarConfig {

    /// The standard rich text format toolbar configuration.
    static var standard: Self { .init() }
}

public extension View {

    /// Apply a rich text format toolbar style.
    func richTextFormatToolbarConfig(
        _ value: RichTextFormat.ToolbarConfig
    ) -> some View {
        self.environment(\.richTextFormatToolbarConfig, value)
    }
}

private extension RichTextFormat.ToolbarConfig {

    struct Key: EnvironmentKey {

        public static var defaultValue: RichTextFormat.ToolbarConfig {
            .init()
        }
    }
}

public extension EnvironmentValues {

    /// This value can bind to a format toolbar config.
    var richTextFormatToolbarConfig: RichTextFormat.ToolbarConfig {
        get { self [RichTextFormat.ToolbarConfig.Key.self] }
        set { self [RichTextFormat.ToolbarConfig.Key.self] = newValue }
    }
}
#endif
