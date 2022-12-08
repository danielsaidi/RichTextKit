//
//  MainMenu.swift
//  Demo (iOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct MainMenu: View {

    @State
    private var isSheetPresented = false

    var body: some View {
        Menu {
            link(to: .about)
            webLink(to: .github)
            webLink(to: .documentation)
        } label: {
            Image.menu
        }.sheet(isPresented: $isSheetPresented) {
            NavigationView {
                AboutScreen(showTitle: false)
            }.navigationViewStyle(.stack)
        }
    }
}

extension MainMenu {

    func link(to screen: DemoScreen) -> some View {
        Button(action: { isSheetPresented = true }) {
            screen.label
        }
    }

    func webLink(to url: DemoUrl) -> some View {
        Link(destination: url.url) {
            url.label
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
