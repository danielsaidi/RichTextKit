//
//  DemoEditorScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Kankoda Sweden AB. All rights reserved.
//

import RichTextKit
import SwiftUI

struct DemoEditorScreen: View {

    @Binding var document: DemoDocument

    @State private var isInspectorPresented = false

    @StateObject var context = RichTextContext()

    var body: some View {
        VStack(spacing: 0) {
            #if os(macOS)
            RichTextFormat.Toolbar(context: context)
            #endif
            RichTextEditor(
                text: $document.text,
                context: context
            ) {
                $0.textContentInset = CGSize(width: 30, height: 30)
            }
            // Use this to just view the text:
            // RichTextViewer(document.text)
            #if os(iOS)
            RichTextKeyboardToolbar(
                context: context,
                leadingButtons: { $0 },
                trailingButtons: { $0 },
                formatSheet: { $0 }
            )
            #endif
        }
        .inspector(isPresented: $isInspectorPresented) {
            RichTextFormat.Sidebar(context: context)
                #if os(macOS)
                .inspectorColumnWidth(min: 280, ideal: 350, max: 400)
                #endif
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Toggle(isOn: $isInspectorPresented) {
                    Image.richTextFormatBrush
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            
        }
        .frame(minWidth: 500)
        .focusedValue(\.richTextContext, context)
        .toolbarRole(.automatic)
        .richTextFormatSheetConfig(.init(colorPickers: colorPickers))
        .richTextFormatSidebarConfig(
            .init(
                colorPickers: colorPickers,
                fontPicker: isMac
            )
        )
        .richTextFormatToolbarConfig(.init(colorPickers: []))
        .sheet(isPresented: $context.isLinkSheetPresented) {
            RichTextFormat.LinkInput(
                context: context,
                isPresented: $context.isLinkSheetPresented
            )
            #if macOS
            .frame(width: 400)
            #endif
        }
    }
}

private extension DemoEditorScreen {

    var isMac: Bool {
        #if os(macOS)
        true
        #else
        false
        #endif
    }

    var colorPickers: [RichTextColor] {
        [.foreground, .background]
    }

    var formatToolbarEdge: VerticalEdge {
        isMac ? .top : .bottom
    }
}

#Preview {
    DemoEditorScreen(
        document: .constant(DemoDocument()),
        context: .init()
    )
}
