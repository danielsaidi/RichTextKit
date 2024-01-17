//
//  View+RichTextAction.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAction {
 
    /**
     This view modifier can be used to apply keyboard action
     shortcuts to any view.
     
     You can also apply it with the `.keyboardShortcut(for:)`
     view extension.
     
     > Note: This modifier only has effect on some platform.
     */
    struct KeyboardShortcutModifier: ViewModifier {
        
        public init(_ action: RichTextAction) {
            self.action = action
        }
        
        private let action: RichTextAction
        
        public func body(content: Content) -> some View {
            #if iOS || macOS || os(visionOS)
            switch action {
            case .copy: content.keyboardShortcut("c", modifiers: .command)
            case .dismissKeyboard: content
            case .print: content.keyboardShortcut("p", modifiers: .command)
            case .redoLatestChange: content.keyboardShortcut("z", modifiers: [.command, .shift])
            case .setAlignment(let align): content.keyboardShortcut(for: align)
            case .stepFontSize(let points): content.keyboardShortcut(points < 0 ? "-" : "+", modifiers: .command)
            case .stepIndent(let steps): content.keyboardShortcut(steps < 0 ? "Ö" : "Ä", modifiers: .command)
            case .stepSuperscript: content
            case .toggleStyle(let style): content.keyboardShortcut(for: style)
            case .undoLatestChange: content.keyboardShortcut("z", modifiers: .command)
            }
            #else
            content
            #endif
        }
    }
}

public extension View {

    /// Apply a rich text action keyboard shortcut.
    @ViewBuilder
    func keyboardShortcut(for action: RichTextAction) -> some View {
        modifier(RichTextAction.KeyboardShortcutModifier(action))
    }
}
