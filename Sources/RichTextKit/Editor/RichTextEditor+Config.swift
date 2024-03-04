//
//  RichTextEditor+Config.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-24.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

/// This struct be used to configure a ``RichTextEditor``.
public typealias RichTextEditorConfig = RichTextView.Configuration

public extension View {

    /// Apply a ``RichTextEditor`` configuration.
    func richTextEditorConfig(
        _ config: RichTextEditorConfig
    ) -> some View {
        self.environment(\.richTextEditorConfig, config)
    }
}

private extension RichTextEditorConfig {
    
    struct Key: EnvironmentKey {
        
        public static var defaultValue: RichTextEditorConfig = .standard
    }
}

public extension EnvironmentValues {

    /// This value can bind to a rich text editor config.
    var richTextEditorConfig: RichTextEditorConfig {
        get { self [RichTextEditorConfig.Key.self] }
        set { self [RichTextEditorConfig.Key.self] = newValue }
    }
}
#endif
