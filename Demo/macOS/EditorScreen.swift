//
//  EditorScreen.swift
//  Demo (macOS)
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
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                editor
                Divider()
                toolbar
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                RichTextActionButtonStack(
                    context: context,
                    actions: [.undo, .redo, .copy]
                )
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
        .frame(minWidth: 400)
        .focusedValue(\.richTextContext, context)
    }

    var toolbar: some View {
        RichTextFormatSidebar(context: context)
            .frame(width: 250)
    }
}

struct EditorScreen_Previews: PreviewProvider {

    static var previews: some View {
        EditorScreen()
    }
}
