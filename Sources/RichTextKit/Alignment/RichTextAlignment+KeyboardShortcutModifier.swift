//
//  RichTextAlignment+KeyboardShortcutModifier.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-17.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAlignment {

    /**
     This view modifier can apply keyboard shortcuts for any
     ``RichTextAlignment`` to any view.

     You can also apply it with the `.keyboardShortcut(for:)`
     view modifier.
     */
    struct KeyboardShortcutModifier: ViewModifier {

        public init(_ alignment: RichTextAlignment) {
            self.alignment = alignment
        }

        private let alignment: RichTextAlignment

        public func body(content: Content) -> some View {
            content.keyboardShortcut(for: alignment)
        }
    }
}

public extension View {

    /**
     Add a keyboard shortcut that toggles a certain style.

     This modifier only has effect on platforms that support
     keyboard shortcuts.
     */
    @ViewBuilder
    func keyboardShortcut(for alignment: RichTextAlignment) -> some View {
        #if iOS || macOS || os(visionOS)
        switch alignment {
        case .left: keyboardShortcut("Ö", modifiers: [.command, .shift])
        case .center: keyboardShortcut("*", modifiers: [.command])
        case .right: keyboardShortcut("Ä", modifiers: [.command, .shift])
        case .justified: self
        }
        #else
        self
        #endif
    }
}
