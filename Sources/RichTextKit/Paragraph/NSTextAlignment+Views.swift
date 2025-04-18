//
//  NSTextAlignment+Views.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2025-04-06.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

extension NSTextAlignment: @retroactive Identifiable {

    public var id: Int { rawValue }
}

public extension NSTextAlignment {

    /// The default icon for the text alignment.
    var defaultIcon: Image {
        switch self {
        case .center: .richTextAlignmentCenter
        case .justified: .richTextAlignmentJustified
        case .left: .richTextAlignmentLeft
        case .natural: .richTextAlignmentLeft
        case .right: .richTextAlignmentRight
        @unknown default: .richTextUnknownValueType
        }
    }

    #if iOS || macOS || os(visionOS)
    /// The default keyboard shortcut, if any.
    var defaultKeyboardShortcut: KeyboardShortcut? {
        switch self {
        case .left: .init("Ö", modifiers: [.command, .shift])
        case .center: .init("*", modifiers: [.command])
        case .right: .init("Ä", modifiers: [.command, .shift])
        default: nil
        }
    }
    #endif

    /// The default label for the text alignment.
    var defaultLabel: some View {
        Label {
            Text(defaultTitle)
        } icon: {
            defaultIcon
        }
    }

    /// The standard title to use for the alignment.
    var defaultTitle: String {
        defaultTitleKey.text
    }

    /// The standard title key to use for the alignment.
    var defaultTitleKey: RTKL10n {
        switch self {
        case .left: .textAlignmentLeft
        case .right: .textAlignmentRight
        case .center: .textAlignmentCentered
        case .justified: .textAlignmentJustified
        default: .textAlignmentLeft
        }
    }
}

public extension View {

    /// Apply keyboard shortcuts for a ``RichTextAlignment``
    /// to the view.
    @ViewBuilder
    func keyboardShortcut(
        for alignment: NSTextAlignment
    ) -> some View {
        #if iOS || macOS || os(visionOS)
        if let shortcut = alignment.defaultKeyboardShortcut {
            self.keyboardShortcut(shortcut)
        } else {
            self
        }
        #else
        self
        #endif
    }
}
