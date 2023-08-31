//
//  DemoApp.swift
//  Shared
//
//  Created by Daniel Saidi on 2022-05-22.
//

import SwiftUI
import RichTextKit

@main
struct DemoApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            #if os(macOS)
            AboutCommand()
            RichTextFormatCommandMenu()
            RichTextShareCommandMenu(
                isEnabled: true,
                shareFormats: .libraryFormats,
                exportFormats: RichTextDataFormat.archivedData.convertibleFormats,
                // formatShareAction: { print("TODO: Share file for \($0.id)") },
                // pdfShareAction: { print("TODO: Share PDF file") },
                formatNSSharingAction: {
                    print("TODO: Share file for \($0.id)")
                    return nil
                },
                pdfNSSharingAction: {
                    print("TODO: Share PDF file")
                    return nil
                },
                formatExportAction: { print("TODO: Export file for \($0.id)") },
                pdfExportAction: { print("TODO: Export PDF file") },
                printAction: { print("TODO: Export document") }
            )
            SidebarCommands()
            #endif
        }
    }
}
