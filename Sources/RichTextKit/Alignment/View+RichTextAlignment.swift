//
//  View+RichTextAlignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-17.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /**
     Add a keyboard shortcut that toggles a certain style.

     This modifier only has effect on platforms that support
     keyboard shortcuts.
     */
    @ViewBuilder
    func keyboardShortcut(for alignment: RichTextAlignment) -> some View {
        #if os(iOS) || os(macOS)
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
