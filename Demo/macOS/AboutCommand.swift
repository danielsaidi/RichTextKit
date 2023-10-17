//
//  AboutCommand.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This command customzies the system menu's about app option.
 */
struct AboutCommand: Commands {

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About RichTextKit") {
                NSApplication.shared.orderFrontStandardAboutPanel(options: .richTextKit)
            }
        }
    }
}

extension Dictionary where Key == NSApplication.AboutPanelOptionKey, Value == Any {

    /**
     This dictionary has Oribi Writer-specific info that can
     be used in an AppKit about panel.
     */
    static var richTextKit: [NSApplication.AboutPanelOptionKey: Any] {
        [
            .applicationName: "RichTextKit",
            .credits: NSAttributedString(
                string: "RichTextKit is developed by Daniel Saidi.",
                attributes: [
                    .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
                ]
            )
        ]
    }
}
