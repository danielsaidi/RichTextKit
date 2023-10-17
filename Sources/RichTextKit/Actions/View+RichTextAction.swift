//
//  View+RichTextAction.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /**
     Add a keyboard shortcut that triggers a certain action.
     */
    @ViewBuilder
    func keyboardShortcut(for action: RichTextAction) -> some View {
        #if os(iOS) || os(macOS)
        switch action {
        case .copy: keyboardShortcut("c", modifiers: .command)
        case .dismissKeyboard: self
        case .incrementFontSize: keyboardShortcut("+", modifiers: .command)
        case .decrementFontSize: keyboardShortcut("-", modifiers: .command)
        case .increaseIndent: self
        case .decreaseIndent: self
        case .print: keyboardShortcut("p", modifiers: .command)
        case .redoLatestChange: keyboardShortcut("z", modifiers: [.command, .shift])
        case .undoLatestChange: keyboardShortcut("z", modifiers: .command)
        }
        #else
        self
        #endif
    }
}
