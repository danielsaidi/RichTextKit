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
            sectionLink(to: .aboutApp)
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

    func buttonBody(title: String, icon: Image) -> some View {
        HStack {
            Label {
                Text(title)
            } icon: {
                icon
            }
        }
    }

    func sectionLink(to section: DemoSection) -> some View {
        Button(action: { isSheetPresented = true }) {
            buttonBody(title: section.title, icon: section.icon)
        }

    }

    func webLink(to url: DemoUrl) -> some View {
        Link(destination: url.url) {
            buttonBody(title: url.title, icon: url.icon)
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
