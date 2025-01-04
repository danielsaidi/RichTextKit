//
//  RichTextAlignment+KeyboardShortcutModifier.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-17.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAlignment {

    /// Apply keyboard shortcuts for a ``RichTextAlignment``
    /// to the view.
    ///
    /// You can also use ``SwiftUICore/View/keyboardShortcut(for:)-22ksm``.
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

    /// Apply keyboard shortcuts for a ``RichTextAlignment``
    /// to the view.
    @ViewBuilder
    func keyboardShortcut(for alignment: RichTextAlignment) -> some View {
        #if iOS || macOS || os(visionOS)
        switch alignment {
        case .left: self.keyboardShortcut("l", modifiers: [.command, .shift])
        case .center: self.keyboardShortcut("e", modifiers: [.command, .shift])
        case .right: self.keyboardShortcut("r", modifiers: [.command, .shift])
        case .justified: self.keyboardShortcut("j", modifiers: [.command, .shift])
        }
        #else
        self
        #endif
    }
}
