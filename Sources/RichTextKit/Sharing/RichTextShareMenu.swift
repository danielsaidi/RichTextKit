//
//  RichTextShareMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This menu can be used to trigger custom share actions for a
 list of ``RichTextDataFormat`` values.

 This menu uses a ``RichTextDataFormatMenu`` that by default
 is configured for exporting. It has customizable actions to
 make it possible to use it in any custom way.

 If you have a ``RichTextDataFormat`` value, you can use its
 ``RichTextDataFormat/convertibleFormats`` as init parameter
 to get an export menu for all other formats.
 */
public struct RichTextShareMenu: View {

    public init(
        title: String = RTKL10n.menuShareAs.text,
        icon: Image = .richTextActionShare,
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

struct RichTextShareMenu_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            RichTextShareMenu(
                formatAction: { _ in },
                pdfAction: {}
            )
        }
    }
}
#endif
