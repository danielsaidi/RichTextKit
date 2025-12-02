//
//  View+RichTextStyle.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /// Add a keyboard shortcut that toggles a certain style.
    ///
    /// This modifier only has effect on platforms that support keyboard shortcuts.
    @ViewBuilder
    func keyboardShortcut(for style: RichTextStyle) -> some View {
        #if iOS || macOS || os(visionOS)
        switch style {
        case .bold: keyboardShortcut("b", modifiers: .command)
        case .italic: keyboardShortcut("i", modifiers: .command)
        case .strikethrough: self
        case .underlined: keyboardShortcut("u", modifiers: .command)
        case .link: keyboardShortcut("k", modifiers: .command)
        }
        #else
        self
        #endif
    }
}
