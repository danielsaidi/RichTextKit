//
//  DemoApp.swift
//  Demo
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Kankoda Sweden AB. All rights reserved.
//

import RichTextKit
import SwiftUI

@main
struct DemoApp: App {
    
    var body: some Scene {
        
        DocumentGroup(newDocument: DemoDocument()) { file in
            DemoEditor(
                document: file.$document
            )
        }
        .commands {
            SidebarCommands()
            #if os(macOS)
            AboutCommand()
            #endif
            RichTextCommand.FormatMenu()
            
            CommandMenu("RichTextKit") {
                DemoUrl.github.link
                DemoUrl.documentation.link
            }
        }
    }
}
