//
//  RichTextShareCommandMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This command menu can be used to add rich text menu options
 for share, export and print to an app's menu bar.

 The menu includes sharing, exporting and printing. Clicking
 an option will trigger custom actions that you provide.

 Regarding sharing, the macOS exclusive `nsSharing` commands
 require you to return a share url, after which the commands
 take care of the sharing.
 
 Note that a pdf action menu will only be included if it has
 a corresponding action. You must also add `isEnabled: false`
 to disable the menu, since you can't add `.disabled` to the
 command menu.
 
 Setting an action to `nil` removes the option from the menu.
 */
public struct RichTextShareCommandMenu: Commands {

    /**
     Create a rich text share command menu.

     Setting `formatNSSharingAction` and `pdfNSSharingAction`
     will only have an effect on macOS and will then be used
     to add a ``RichTextNSSharingMenu`` to this command menu.
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
            }.disabled(!isEnabled)
        }
    }
}

private extension RichTextShareCommandMenu {

    var hasExportFormats: Bool { !exportFormats.isEmpty }

    var hasShareFormats: Bool { !shareFormats.isEmpty }
}

private extension RichTextShareCommandMenu {

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
            }.keyboardShortcut(for: .print)
        }
    }

    @ViewBuilder
    var nssharingMenu: some View {
        #if os(macOS)
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
