//
//  EditorScreen.swift
//  Demo (iOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorScreen: View {

    init() {
        // RichTextEditor.standardRichTextFontSize = 100
    }

    @State
    private var text = NSAttributedString.empty

    @StateObject
    var context = RichTextContext()

    var body: some View {
        VStack {
            editor.padding()
            toolbar
        }
        .background(Color.primary.opacity(0.15))
        .navigationTitle("RichTextKit")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                MainMenu()
            }
        }
        .viewDebug()
    }
}

private extension EditorScreen {

    var editor: some View {
        RichTextEditor(text: $text, context: context, linkColor: .green) {
            $0.textContentInset = CGSize(width: 10, height: 20)
        }
        .background(Material.regular)
        .cornerRadius(5)
        .focusedValue(\.richTextContext, context)
    }

    var toolbar: some View {
        RichTextKeyboardToolbar(
            context: context,
            leadingButtons: {},
            trailingButtons: {}
        )
    }
}

struct EditorScreen_Previews: PreviewProvider {

    static var previews: some View {
        EditorScreen()
    }
}
