//
//  RichTextFormat+ToolbarStyle.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-16.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormat {

    /// This type can be used to style a format toolbar.
    struct ToolbarStyle {

        public init(
            padding: Double = 10,
            spacing: Double = 10
        ) {
            self.padding = padding
            self.spacing = spacing
        }

        public var padding: Double
        public var spacing: Double
    }
}

public extension View {

    /// Apply a rich text format toolbar style.
    func richTextFormatToolbarStyle(
        _ style: RichTextFormat.ToolbarStyle
    ) -> some View {
        self.environment(\.richTextFormatToolbarStyle, style)
    }
}

private extension RichTextFormat.ToolbarStyle {

    struct Key: EnvironmentKey {

        public static let defaultValue = RichTextFormat.ToolbarStyle()
    }
}

public extension EnvironmentValues {

    /// This value can bind to a format toolbar style.
    var richTextFormatToolbarStyle: RichTextFormat.ToolbarStyle {
        get { self [RichTextFormat.ToolbarStyle.Key.self] }
        set { self [RichTextFormat.ToolbarStyle.Key.self] = newValue }
    }
}
#endif
