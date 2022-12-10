//
//  AboutScreen.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

struct AboutScreen: View {

    init(showTitle: Bool = true) {
        self.showTitle = showTitle
    }

    private let showTitle: Bool

    private let titleText = "About this app"

    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    title
                    aboutText
                    Spacer()
                }.padding()
            }
            Spacer()
        }
        .navigationTitle(titleText)
    }
}

private extension AboutScreen {

    var aboutText: some View {
        Text("""
This demo aims to demonstrate what is currently possible with RichTextKit. The demo is currently limited, but will be refined in the future.

You can run the demo in both iOS and macOS, and will get a different layout for the various platforms. The macOS demo has a side menu with options, from which you can navigate around in the app, while the iOS demo just has a simple menu.

Both demo apps should be improved a great deal, especially the iOS demo. The goal is to have it look like a basic Notes och Pages app, which requires some adjustment on all platforms.

In the demo, you can type in the rich text editor, change styles, font, font size, alignment as well as colors. You can also try the paste and undo/redo feature.

The demo also supports dragging or pasting in images.
""").font(.body)
    }

    @ViewBuilder
    var title: some View {
        if showTitle {
            Text(titleText)
                .font(.largeTitle)
        }
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}
