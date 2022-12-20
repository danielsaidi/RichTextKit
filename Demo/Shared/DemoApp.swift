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
            SidebarCommands()
            #endif
        }
    }
}
