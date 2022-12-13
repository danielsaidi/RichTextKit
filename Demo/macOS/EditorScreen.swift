//
//  EditorScreen.swift
//  Demo (macOS)
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
                RichTextActionButtonStack(context: context)
            }
        }
    }
}

private extension EditorScreen {

    var editor: some View {
        RichTextEditor(text: $text, context: context) {
            $0.textContentInset = CGSize(width: 10, height: 20)
        }.frame(minWidth: 400)
    }

    var toolbar: some View {
        Toolbar {
            SidebarSection(title: "Font") {
                RichTextFontPicker(selection: $context.fontName, fontSize: 12)
                HStack {
                    RichTextStyleToggleStack(context: context)
                    RichTextFontSizePickerStack(context: context)
                }
            }
            SidebarSection(title: "Color") {
                HStack {
                    Text("Text color")
                    Spacer()
                    RichTextColorPicker(color: .foreground, context: context)
                }
                HStack {
                    Text("Background color")
                    Spacer()
                    RichTextColorPicker(color: .background, context: context)
                }
            }
            SidebarSection(title: "Alignment") {
                RichTextAlignmentPicker(selection: $context.textAlignment)
            }
            Spacer()
        }.frame(width: 250)
    }
}

private struct Toolbar<Content: View>: View {

    @ViewBuilder
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content()
        }
        .padding(8)
        .background(Color.white.opacity(0.05))
    }
}

private struct SidebarSection<Content: View>: View {

    let title: String

    @ViewBuilder
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content()
            Divider()
        }
    }
}

struct EditorScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        EditorScreen()
    }
}
