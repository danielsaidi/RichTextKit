//
//  MainMenu.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct MainMenu: View {

    @Binding
    var section: DemoSection

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                Text("RichTextKit")
                    .font(.largeTitle)
                    .padding(.bottom)
                menuItems
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.primary)
        .frame(minWidth: 200)
        .padding()
    }
}

extension MainMenu {

    var menuItems: some View {
        VStack(alignment: .leading, spacing: 5) {
            sectionLink(to: .textEditor)
            sectionLink(to: .aboutApp)
            webLink(to: .github)
            webLink(to: .documentation)
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
            Spacer()
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity)
        .padding(10)
        .font(.title2)
    }

    func sectionLink(to section: DemoSection) -> some View {
        Button(action: { self.section = section }) {
            buttonBody(title: section.title, icon: section.icon)
        }
        .buttonStyle(.plain)
        .background(sectionLinkBackground(for: section))

    }

    func sectionLinkBackground(for section: DemoSection) -> some View {
        sectionLinkBackgroundColor(for: section)
            .cornerRadius(10)
    }

    func sectionLinkBackgroundColor(for section: DemoSection) -> some View {
        isSelected(section) ? Color.white.opacity(0.1) : Color.clear
    }

    func webLink(to url: DemoUrl) -> some View {
        Link(destination: url.url) {
            buttonBody(title: url.title, icon: url.icon)
        }
    }
}

extension MainMenu {

    func isSelected(_ section: DemoSection) -> Bool {
        self.section == section
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu(section: .constant(.textEditor))
    }
}
