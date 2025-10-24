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

    /// This menu adds share options to the main menu.
    ///
    /// This menu will attempt to add menu options for share, export and print, if
    /// applicable to the platform.
    ///
    /// The macOS exclusive `nsSharing` commands require you to return a
    /// share url, after which the command takes care of the sharing. The optional
    /// `formatNSSharingAction` and `pdfNSSharingAction` works
    /// on macOS, where they add ``RichTextNSSharingMenu`` options.
    ///
    /// Note that a PDF action menu will only be included if it has an action. You
    /// must use `isEnabled: false` to disable the menu, since you can't
    /// add `.disabled` to the command menu.
    ///
    /// Setting an action to `nil` removes the related menu.
    struct ShareMenu: Commands {

        /// Create a rich text share command menu.
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
                RichTextAction.print.label
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
