//
//  RichTextDataFormat+Menu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextDataFormat {

    /**
     This menu can be used to trigger custom actions for any
     list of ``RichTextDataFormat`` values.

     The menu uses customizable actions, which means that it
     can be used in toolbars, menu bar commands etc. It also
     has an optional `pdf` action, which for instance can be
     used when exporting or sharing rich text.
     */
    struct Menu: View {

        public init(
            title: String,
            icon: Image,
            formats: [Format] = Format.libraryFormats,
            formatAction: @escaping (Format) -> Void,
            pdfAction: (() -> Void)? = nil
        ) {
            self.title = title
            self.icon = icon
            self.formats = formats
            self.formatAction = formatAction
            self.pdfAction = pdfAction
        }

        public typealias Format = RichTextDataFormat

        private let title: String
        private let icon: Image
        private let formats: [Format]
        private let formatAction: (Format) -> Void
        private let pdfAction: (() -> Void)?

        public var body: some View {
            SwiftUI.Menu {
                ForEach(formats) { format in
                    Button {
                        formatAction(format)
                    } label: {
                        Label(format.fileFormatText, icon)
                    }
                }
                if let action = pdfAction {
                    Button(action: action) {
                        Label(RTKL10n.fileFormatPdf.text, icon)
                    }
                }
            } label: {
                Label(title, icon)
            }
        }
    }
}

struct RichTextData_FormatMenu_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            RichTextDataFormat.Menu(
                title: "Export...",
                icon: .richTextActionExport,
                formatAction: { _ in },
                pdfAction: {}
            )
        }
    }
}
#endif
