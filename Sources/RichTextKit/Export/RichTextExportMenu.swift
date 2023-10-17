//
//  RichTextExportMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This menu can be used to trigger various export actions for
 a list of ``RichTextDataFormat`` values.

 This menu uses a ``RichTextDataFormatMenu`` that by default
 is configured for exporting. It has customizable actions to
 make it possible to use it in any custom way.

 If you have a ``RichTextDataFormat`` value, you can use its
 ``RichTextDataFormat/convertibleFormats`` as init parameter
 to get an export menu for all other formats.
 */
public struct RichTextExportMenu: View {

    public init(
        title: String = RTKL10n.menuExportAs.text,
        icon: Image = .richTextActionExport,
        formats: [RichTextDataFormat] = RichTextDataFormat.libraryFormats,
        formatAction: @escaping (RichTextDataFormat) -> Void,
        pdfAction: (() -> Void)? = nil
    ) {
        self.menu = RichTextDataFormatMenu(
            title: title,
            icon: icon,
            formats: formats,
            formatAction: formatAction,
            pdfAction: pdfAction
        )
    }

    private let menu: RichTextDataFormatMenu

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
