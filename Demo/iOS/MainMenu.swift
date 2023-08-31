//
//  MainMenu.swift
//  Demo (iOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI
import RichTextKit

struct MainMenu: View {

    @State
    private var isSheetPresented = false

    var body: some View {
        Menu {
            RichTextShareMenu(
                formats: .libraryFormats,
                formatAction: { print("TODO: Share file for \($0.id)") },
                pdfAction: { print("TODO: Share PDF file") })
            RichTextExportMenu(
                formats: .libraryFormats,
                formatAction: { print("TODO: Export file for \($0.id)") },
                pdfAction: { print("TODO: Export PDF file") })
            Divider()
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
