//
//  ContentView.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct ContentView: View {

    @State
    private var section = DemoSection.textEditor

    @State
    private var text = NSAttributedString(string: "test")

    @StateObject
    var context = RichTextContext()

    var body: some View {
        NavigationView {
            MainMenu(section: $section)
            sectionView
                .navigationTitle("RichTextKit")
        }
    }
}

extension ContentView {

    @ViewBuilder
    var sectionView: some View {
        switch section {
        case .aboutApp:
            AboutScreen()
        case .textEditor:
            EditorScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
