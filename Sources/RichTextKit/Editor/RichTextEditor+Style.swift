//
//  RichTextEditor+Style.swift
//  RichTextKit
//
//  Created by Ryan Jarvis on 2024-02-24.
//


#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

/// This struct can be used to style a ``RichTextEditor``.
public typealias RichTextEditorStyle = RichTextView.Theme

public extension View {

    /// Apply a ``RichTextEditor`` style.
    func richTextEditorStyle(
        _ style: RichTextEditorStyle
    ) -> some View {
        self.environment(\.richTextEditorStyle, style)
    }
}

private extension RichTextEditorStyle {
    
    struct Key: EnvironmentKey {
        
        static var defaultValue: RichTextEditorStyle = .standard
    }
}

public extension EnvironmentValues {

    /// This value can bind to a rich text editor style.
    var richTextEditorStyle: RichTextEditorStyle {
        get { self [RichTextEditorStyle.Key.self] }
        set { self [RichTextEditorStyle.Key.self] = newValue }
    }
}
#endif
