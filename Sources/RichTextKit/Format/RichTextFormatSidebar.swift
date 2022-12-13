//
//  RichTextFormatSidebar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This sidebar view provides various text format options, and
 is meant to be used on macOS, in a trailing sidebar.

 Although the view is designed to be used on macOS, it's not
 excluded for the other platforms, although it will probably
 feel off on them.
 */
public struct RichTextFormatSidebar: View {

    /**
     Create a rich text format sheet.

     - Parameters:
       - context: The context to apply changes to.
     */
    public init(
        context: RichTextContext
    ) {
        self._context = ObservedObject(wrappedValue: context)
    }

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
                    .pickerStyle(.segmented)
            }
            Spacer()
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

struct RichTextFormatSidebar_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextFormatSidebar(context: context)
        }
    }

    static var previews: some View {
        Preview()
            .frame(width: 250)
    }
}
