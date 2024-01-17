//
//  RichTextAction+KeyboardShortcutModifier.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAction {
 
    /**
     This view modifier can apply keyboard shortcuts for any
     ``RichTextAction`` to any view.
     
     You can also apply it with the `.keyboardShortcut(for:)`
     view extension.
     */
    struct KeyboardShortcutModifier: ViewModifier {
        
        public init(_ action: RichTextAction) {
            self.action = action
        }
        
        private let action: RichTextAction
        
        public func body(content: Content) -> some View {
            content.keyboardShortcut(for: action)
        }
    }
}

public extension View {

    /// Apply a ``RichTextAction/KeyboardShortcutModifier``.
    @ViewBuilder
    func keyboardShortcut(for action: RichTextAction) -> some View {
        #if iOS || macOS || os(visionOS)
        switch action {
        case .copy: keyboardShortcut("c", modifiers: .command)
        case .dismissKeyboard: self
        case .print: keyboardShortcut("p", modifiers: .command)
        case .redoLatestChange: keyboardShortcut("z", modifiers: [.command, .shift])
        case .setAlignment(let align): keyboardShortcut(for: align)
        case .stepFontSize(let points): keyboardShortcut(points < 0 ? "-" : "+", modifiers: .command)
        case .stepIndent(let steps): keyboardShortcut(steps < 0 ? "Ö" : "Ä", modifiers: .command)
        case .stepSuperscript: self
        case .toggleStyle(let style): keyboardShortcut(for: style)
        case .undoLatestChange: keyboardShortcut("z", modifiers: .command)
        }
        #else
        self
        #endif
    }
}
