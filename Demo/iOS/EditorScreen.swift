//
//  EditorScreen.swift
//  Demo (iOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorScreen: View {

    @State
    private var text = NSAttributedString(string: "Type here...")

    @StateObject
    var context = RichTextContext()

    var body: some View {
        VStack(spacing: 10) {
            editor
            topToolbar
            Divider()
            midToolbar
            Divider()
            bottomToolbar
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .navigationTitle("RichTextKit")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                MainMenu()
            }
        }
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

    var topToolbar: some View {
        HStack {
            RichTextFontPicker(selection: $context.fontName, fontSize: 12)
            Spacer()
            RichTextFontSizePickerGroup(selection: $context.fontSize)
        }
    }

    var midToolbar: some View {
        HStack {
            RichTextStyleToggleGroup(context: context)
            Spacer()
            RichTextAlignmentPicker(selection: $context.textAlignment)
        }
    }

    var bottomToolbar: some View {
        HStack {
            RichTextActionButtonGroup(context: context)
                .buttonStyle(.bordered)
            Spacer()
            RichTextColorPickerGroup(context: context)
        }
    }
}

struct EditorScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        EditorScreen()
    }
}
