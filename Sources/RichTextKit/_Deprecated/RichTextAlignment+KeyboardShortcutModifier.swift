//
//  RichTextAlignment+KeyboardShortcutModifier.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-17.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

@available(*, deprecated, message: "Use native NSTextAlignment directly")
public extension RichTextAlignment {

    /// Apply keyboard shortcuts for a ``RichTextAlignment``
    /// to the view.
    struct KeyboardShortcutModifier: ViewModifier {

        public init(_ alignment: RichTextAlignment) {
            self.alignment = alignment
        }

        private let alignment: RichTextAlignment

        public func body(content: Content) -> some View {
            content.keyboardShortcut(for: alignment.nativeAlignment)
        }
    }
}
