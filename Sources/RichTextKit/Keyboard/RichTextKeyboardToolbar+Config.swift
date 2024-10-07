//
//  RichTextKeyboardToolbar+Config.swift
//  RichTextKit
//
//  Created by Ryan Jarvis on 2024-02-24.
//  Copyright © 2023-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/// This struct can configure a ``RichTextKeyboardToolbar``.
public struct RichTextKeyboardToolbarConfig {

    /// Create a custom keyboard toolbar configuration.
    ///
    /// - Parameters:
    ///   - alwaysDisplayToolbar: Whether or not to always show the toolbar, by default `false`.
    ///   - leadingActions: The leading actions, by default `.undo` and `.redo`.
    ///   - trailingActions: The trailing actions, by default `.dismissKeyboard`.
    public init(
        alwaysDisplayToolbar: Bool = false,
        leadingActions: [RichTextAction] = [.undo, .redo],
        trailingActions: [RichTextAction] = [.dismissKeyboard]
    ) {
        self.alwaysDisplayToolbar = alwaysDisplayToolbar
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
    }

    /// Whether or not to always show the toolbar.
    public var alwaysDisplayToolbar: Bool

    /// The leading toolbar actions.
    public var leadingActions: [RichTextAction]

    /// The trailing toolbar actions.
    public var trailingActions: [RichTextAction]
}

public extension RichTextKeyboardToolbarConfig {

    /// The standard rich text keyboard toolbar config.
    static var standard: Self { .init() }
}

public extension View {

    /// Apply a ``RichTextKeyboardToolbar`` configuration.
    func richTextKeyboardToolbarConfig(
        _ config: RichTextKeyboardToolbarConfig
    ) -> some View {
        self.environment(\.richTextKeyboardToolbarConfig, config)
    }
}

private extension RichTextKeyboardToolbarConfig {

    struct Key: EnvironmentKey {

        public static var defaultValue: RichTextKeyboardToolbarConfig {
            .standard
        }
    }
}

public extension EnvironmentValues {

    /// This value can bind to a keyboard toolbar config.
    var richTextKeyboardToolbarConfig: RichTextKeyboardToolbarConfig {
        get { self [RichTextKeyboardToolbarConfig.Key.self] }
        set { self [RichTextKeyboardToolbarConfig.Key.self] = newValue }
    }
}
#endif
