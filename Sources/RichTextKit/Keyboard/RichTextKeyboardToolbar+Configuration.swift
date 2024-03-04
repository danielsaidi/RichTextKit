//
//  RichTextKeyboardToolbar+Configuration.swift
//  RichTextKit
//
//  Created by Ryan Jarvis on 2024-02-24.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/// This struct can configure a ``RichTextKeyboardToolbar``.
public struct RichTextKeyboardToolbarConfiguration {

    /// Create a custom toolbar configuration.
    ///
    /// - Parameters:
    ///   - alwaysDisplayToolbar: Whether or not to always show the toolbar, by default `false`.
    public init(
        alwaysDisplayToolbar: Bool = false
    ) {
        self.alwaysDisplayToolbar = alwaysDisplayToolbar
    }

    /// Whether or not to always show the toolbar
    public var alwaysDisplayToolbar: Bool
}

public extension RichTextKeyboardToolbarConfiguration {
    
    /// A standard rich text keyboard toolbar configuration.
    ///
    /// You can override this to change the global default.
    static var standard = RichTextKeyboardToolbarConfiguration()
}

public extension View {

    /// Apply a ``RichTextKeyboardToolbar`` configuration.
    func richTextKeyboardToolbarConfiguration(
        _ configuration: RichTextKeyboardToolbarConfiguration
    ) -> some View {
        self.environment(\.richTextKeyboardToolbarConfiguration, configuration)
    }
}

extension RichTextKeyboardToolbarConfiguration {
    
    struct Key: EnvironmentKey {
        
        public static var defaultValue: RichTextKeyboardToolbarConfiguration = .standard
    }
}

public extension EnvironmentValues {

    var richTextKeyboardToolbarConfiguration: RichTextKeyboardToolbarConfiguration {
        get { self [RichTextKeyboardToolbarConfiguration.Key.self] }
        set { self [RichTextKeyboardToolbarConfiguration.Key.self] = newValue }
    }
}
#endif
