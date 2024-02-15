//
//  RichTextExportMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/**
 This menu can be used to trigger various export actions for
 a list of ``RichTextDataFormat`` values.

 This menu uses a ``RichTextDataFormat/Menu`` configured for
 exporting, with customizable actions and data formats.
 */
public struct RichTextExportMenu: View {

    public init(
        title: String = RTKL10n.menuExportAs.text,
        icon: Image = .richTextActionExport,
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

struct RichTextExportMenu_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            RichTextExportMenu(
                formatAction: { _ in },
                pdfAction: {}
            )
        }
    }
}
#endif
