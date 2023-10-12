//
//  View+RichTextCommand.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-12.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {

    /**
     Add a keyboard shortcut that triggers a certain command.
     */
    @ViewBuilder
    func keyboardShortcut(for command: RichTextCommand) -> some View {
        #if os(iOS) || os(macOS)
        switch command {
        case .print: keyboardShortcut("p", modifiers: .command)
        }
        #else
        self
        #endif
    }
}
