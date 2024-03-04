//
//  DemoEditor.swift
//  Demo
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Kankoda Sweden AB. All rights reserved.
//

import RichTextKit
import SwiftUI

struct DemoEditor: View {
    
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
                .inspectorColumnWidth(min: 200, ideal: 200, max: 315)
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
        .richTextFormatSidebarConfig(.init(colorPickers: colorPickers))
        .richTextFormatToolbarConfig(.init(colorPickers: []))
        .viewDebug()
    }
}

private extension DemoEditor {
    
    var colorPickers: [RichTextColor] {
        [.foreground, .background]
    }
    
    var formatToolbarEdge: VerticalEdge {
        #if os(macOS)
        .top
        #else
        .bottom
        #endif
    }
}

#Preview {
    DemoEditor(
        document: .constant(DemoDocument()),
        context: .init()
    )
}
