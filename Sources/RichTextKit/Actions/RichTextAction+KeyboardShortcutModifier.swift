//
//  RichTextAction+KeyboardShortcutModifier.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAction {

    /// Apply keyboard shortcuts for a ``RichTextAction`` to the view.
    ///
    /// You can also use ``SwiftUICore/View/keyboardShortcut(for:)-9i7js``.
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

    /// Apply keyboard shortcuts for a ``RichTextAction`` to the view.
    @ViewBuilder
    func keyboardShortcut(for action: RichTextAction) -> some View {
        #if iOS || macOS || os(visionOS)
        switch action {
        case .copy: self.keyboardShortcut("c", modifiers: .command)
        case .dismissKeyboard: self
        case .print: self.keyboardShortcut("p", modifiers: .command)
        case .redoLatestChange: self.keyboardShortcut("z", modifiers: [.command, .shift])
        case .setAlignment(let align): self.keyboardShortcut(for: align)
        case .stepFontSize(let points): self.keyboardShortcut(points < 0 ? "-" : "+", modifiers: .command)
        case .stepIndent(let steps): self.keyboardShortcut(steps < 0 ? "Ö" : "Ä", modifiers: .command)
        case .stepSuperscript: self
        case .toggleStyle(let style): self.keyboardShortcut(for: style)
        case .undoLatestChange: self.keyboardShortcut("z", modifiers: .command)
        default: self // TODO: Probably not defined, object to discuss.
        }
        #else
        self
        #endif
    }
}
