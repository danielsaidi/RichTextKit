//
//  RichTextShareMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/// This menu trigger share actions for ``RichTextDataFormat``s.
///
/// The menu wraps a ``RichTextDataFormat/Menu`` that is set up for the
/// exporting, with customizable share actions.
///
/// If you have a ``RichTextDataFormat``, you can use convertible formats
/// as init parameter to get an export menu for all other formats.
public struct RichTextShareMenu: View {

    public init(
        title: String = RTKL10n.menuShareAs.text,
        icon: Image = .richTextShare,
        formats: [RichTextDataFormat] = RichTextDataFormat.libraryFormats,
        formatAction: @escaping (RichTextDataFormat) -> Void,
        pdfAction: (() -> Void)? = nil
    ) {
        self.menu = RichTextDataFormat.Menu(
            title: title,
            icon: icon,
            formats: formats,
            formatAction: formatAction,
            pdfAction: pdfAction
        )
    }

    private let menu: RichTextDataFormat.Menu

    public var body: some View {
        menu
    }
}

#Preview {

    VStack {
        RichTextShareMenu(
            formatAction: { _ in },
            pdfAction: {}
        )
    }
}
#endif
