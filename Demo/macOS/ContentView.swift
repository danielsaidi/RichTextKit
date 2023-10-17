//
//  ContentView.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct ContentView: View {

    @State
    private var screen = DemoScreen.editor

    var body: some View {
        NavigationView {
            MainMenu(selection: $screen)
            screen.view.withSidebarToggle()
        }
    }
}

private extension View {

    func withSidebarToggle() -> some View {
        self.toolbar {
            ToolbarItem(placement: .navigation) {
                SidebarToggleButton()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
