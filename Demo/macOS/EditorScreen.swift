//
//  EditorScreen.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorScreen: View, DemoToolbar {

    @State
    private var text = NSAttributedString(string: "Type here...")

    @State
    private var section = DemoSection.textEditor

    @StateObject
    var context = RichTextContext()

    var body: some View {
        VStack(spacing: 0) {
            EditorTopToolbar()
            Divider()
            editor
            EditorBottomToolbar()
        }.environmentObject(context)
    }
}

private extension EditorScreen {

    var editor: some View {
        RichTextEditor(text: $text, context: context) {
            $0.textContentInset = CGSize(width: 10, height: 20)
        }
    }
}

struct EditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditorScreen()
    }
}
