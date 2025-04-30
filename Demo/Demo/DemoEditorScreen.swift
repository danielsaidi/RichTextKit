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
    @State private var isLinkSheetPresented = false
    @State private var linkURL = ""

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
                .inspectorColumnWidth(min: 200, ideal: 200, max: 315)
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
            
            ToolbarItem(placement: .automatic) {
                Button {
                    if context.hasLink {
                        context.removeLink()
                    } else {
                        isLinkSheetPresented = true
                    }
                } label: {
                    Image(systemName: "link")
                        .foregroundColor(context.hasLink ? .accentColor : .primary)
                }
                .help("Add or remove link")
            }
        }
        .sheet(isPresented: $isLinkSheetPresented) {
            LinkSheet(url: $linkURL) {
                if !linkURL.isEmpty {
                    context.setLink(url: linkURL)
                    linkURL = ""
                }
                isLinkSheetPresented = false
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
        .viewDebug()
    }
}

private struct LinkSheet: View {
    @Binding var url: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Link")
                .font(.headline)
            
            TextField("URL", text: $url)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            
            HStack {
                Button("Cancel") {
                    url = ""
                    onDismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Add") {
                    onDismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(url.isEmpty)
            }
        }
        .padding()
        .frame(width: 400, height: 150)
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
