//
//  RichTextFormatToolbar+Configuration.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormatToolbar {

    /// This struct can be used to configure a format sheet.
    struct Configuration {

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

public extension RichTextFormatToolbar.Configuration {

    /// The standard rich text format toolbar configuration.
    ///
    /// You can set a new value to change the global default.
    static var standard = Self()
}
#endif
