//
//  RichTextCommand+ShreMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextCommand {

    /**
     This menu view can add a list of sharing options to the
     main menu.

     The menu will try to add options for share, export, and
     print, if applicable to the current platform. Selecting
     an option will trigger a corresponding, provided action.

     The macOS exclusive `nsSharing` commands require you to
     return a share url, after which a command takes care of
     the sharing. Also note that the `formatNSSharingAction`
     and `pdfNSSharingAction` will only have effect on macOS,
     where they add ``RichTextNSSharingMenu`` options.

     Note that a pdf action menu will only be included if it
     has a corresponding action. Also note that you must use
     `isEnabled: false` to disable the menu, since you can't
     add `.disabled` to the command menu.

     Setting actions to `nil` removes the related menu items.
     */
    struct ShareMenu: Commands {

        /**
         Create a rich text share command menu.
         */
        public init(
            isEnabled: Bool = true,
            shareFormats: [RichTextDataFormat],
            exportFormats: [RichTextDataFormat],
            formatShareAction: FormatAction? = nil,
            pdfShareAction: PdfAction? = nil,
            formatNSSharingAction: FormatNSSharingAction? = nil,
            pdfNSSharingAction: PdfNSSharingAction? = nil,
            formatExportAction: FormatAction? = nil,
            pdfExportAction: PdfAction? = nil,
            printAction: PrintAction? = nil
        ) {
            self.isEnabled = isEnabled
            self.shareFormats = shareFormats
            self.exportFormats = exportFormats
            self.formatShareAction = formatShareAction
            self.pdfShareAction = pdfShareAction
            self.formatNSSharingAction = formatNSSharingAction
            self.pdfNSSharingAction = pdfNSSharingAction
            self.formatExportAction = formatExportAction
            self.pdfExportAction = pdfExportAction
            self.printAction = printAction
        }

        public typealias FormatAction = (RichTextDataFormat) -> Void
        public typealias FormatNSSharingAction = (RichTextDataFormat) -> URL?
        public typealias PdfAction = () -> Void
        public typealias PdfNSSharingAction = () -> URL?
        public typealias PrintAction = () -> Void

        private let shareFormats: [RichTextDataFormat]
        private let exportFormats: [RichTextDataFormat]

        private let isEnabled: Bool
        private let formatShareAction: FormatAction?
        private let pdfShareAction: PdfAction?
        private let formatNSSharingAction: FormatNSSharingAction?
        private let pdfNSSharingAction: PdfNSSharingAction?
        private let formatExportAction: FormatAction?
        private let pdfExportAction: PdfAction?
        private let printAction: PrintAction?

        public var body: some Commands {
            CommandGroup(replacing: .importExport) {
                Group {
                    nssharingMenu
                    shareMenu
                    exportMenu
                    printButton
                }
                .disabled(!isEnabled)
            }
        }
    }
}

private extension RichTextCommand.ShareMenu {

    var hasExportFormats: Bool {
        !exportFormats.isEmpty
    }

    var hasShareFormats: Bool {
        !shareFormats.isEmpty
    }
}

private extension RichTextCommand.ShareMenu {

    @ViewBuilder
    var exportMenu: some View {
        if hasExportFormats, let action = formatExportAction {
            RichTextExportMenu(
                formats: shareFormats,
                formatAction: action,
                pdfAction: pdfExportAction
            )
        }
    }

    @ViewBuilder
    var printButton: some View {
        if let action = printAction {
            Button(action: action) {
                Label(RTKL10n.menuPrint.text, .richTextActionPrint)
            }
            .keyboardShortcut(for: .print)
        }
    }

    @ViewBuilder
    var nssharingMenu: some View {
        #if macOS
        if hasShareFormats, let action = formatNSSharingAction {
            RichTextNSSharingMenu(
                formats: shareFormats,
                formatAction: action,
                pdfAction: pdfNSSharingAction
            )
        }
        #endif
    }

    @ViewBuilder
    var shareMenu: some View {
        if hasShareFormats, let action = formatShareAction {
            RichTextShareMenu(
                formats: shareFormats,
                formatAction: action,
                pdfAction: pdfShareAction
            )
        }
    }
}
#endif
