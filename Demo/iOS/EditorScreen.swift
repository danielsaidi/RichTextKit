//
//  EditorScreen.swift
//  Demo (iOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorScreen: View, DemoToolbar {

    @State
    private var text = NSAttributedString(string: "Type here...")

    @StateObject
    var context = RichTextContext()

    var body: some View {
        VStack {
            editor
            EditorTopToolbar()
            Divider()
            EditorMidToolbar()
            Divider()
            EditorBottomToolbar()
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .environmentObject(context)
    }
}

private extension EditorScreen {

    var editor: some View {
        RichTextEditor(text: $text, context: context) {
            $0.textContentInset = CGSize(width: 10, height: 20)
        }
        .background(Material.regular)
        .cornerRadius(5)
    }
}

struct EditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorScreen()
    }
}
