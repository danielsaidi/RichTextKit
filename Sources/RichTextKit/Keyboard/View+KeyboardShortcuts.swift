//
//  View+KeyboardShortcuts.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /**
     Add a keyboard shortcut that triggers a certain action.

     This modifier only has effect on platforms that support
     keyboard shortcuts.
     */
    @ViewBuilder
    func keyboardShortcut(for action: RichTextAction) -> some View {
        #if os(iOS) || os(macOS)
        switch action {
        case .copy: keyboardShortcut("c", modifiers: .command)
        case .dismissKeyboard: self
        case .incrementFontSize: keyboardShortcut("+", modifiers: .command)
        case .decrementFontSize: keyboardShortcut("-", modifiers: .command)
        case .redoLatestChange: keyboardShortcut("z", modifiers: [.command, .shift])
        case .undoLatestChange: keyboardShortcut("z", modifiers: .command)
        }
        #else
        self
        #endif
    }

    /**
     Add a keyboard shortcut that toggles a certain style.

     This modifier only has effect on platforms that support
     keyboard shortcuts.
     */
    @ViewBuilder
    func keyboardShortcut(for style: RichTextStyle) -> some View {
        #if os(iOS) || os(macOS)
        switch style {
        case .bold: keyboardShortcut("b", modifiers: .command)
        case .italic: keyboardShortcut("i", modifiers: .command)
        case .strikethrough: self
        case .underlined: keyboardShortcut("u", modifiers: .command)
        }
        #else
        self
        #endif
    }
}
