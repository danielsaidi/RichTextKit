//
//  AboutCommand.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if os(macOS)
import SwiftUI

/// This command customzies the app's About panel.
struct AboutCommand: Commands {

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About RichTextKit") {
                NSApplication.shared
                    .orderFrontStandardAboutPanel(
                        options: .richTextKit
                    )
            }
        }
    }
}

extension Dictionary where Key == NSApplication.AboutPanelOptionKey, Value == Any {

    static var richTextKit: [NSApplication.AboutPanelOptionKey: Any] {
        [
            .applicationName: "RichTextKit",
            .credits: NSAttributedString(
                string: "RichTextKit is an open-source SDK for working with rich text in Swift & SwiftUI.",
                attributes: [
                    .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize),
                    .paragraphStyle: {
                        let style = NSMutableParagraphStyle()
                        style.lineSpacing = 8
                        return style
                    }()
                ]
            )
        ]
    }
}
#endif
