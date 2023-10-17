//
//  RichTextFormatSidebar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This sidebar view provides various text format options, and
 is meant to be used on macOS, in a trailing sidebar.

 > Important: Although this view is designed for macOS, it's
 not excluded for iOS, since it should be to the docs. If we
 find a way to combine all platform docs, we can exclude the
 view for iOS as well. Until then, don't use it on iOS since
 it will look off.
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

    private let spacing = 10.0

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            SidebarSection(title: RTKL10n.font.text) {
                RichTextFontPicker(selection: $context.fontName, fontSize: 12)
                HStack {
                    RichTextStyleToggleGroup(context: context)
                    RichTextFontSizePickerStack(context: context)
                }
            }

            SidebarSection(title: nil) {
                RichTextAlignmentPicker(selection: $context.textAlignment)
                    .pickerStyle(.segmented)
                RichTextActionButtonGroup(
                    context: context,
                    actions: [.decreaseIndent, .increaseIndent]
                )
            }

            SidebarSection(title: nil) {
                VStack(spacing: 4) {
                    RichTextColorPicker(
                        icon: .richTextColorForeground,
                        value: context.binding(for: .foreground),
                        quickColors: .quickPickerColors)
                    RichTextColorPicker(
                        icon: .richTextColorBackground,
                        value: context.binding(for: .background),
                        quickColors: .quickPickerColors)
                }
            }
            .font(.callout)
            .padding(.trailing, -8)

            Spacer()
        }
        .padding(8)
        .background(Color.white.opacity(0.05))
    }
}

private struct SidebarSection<Content: View>: View {

    let title: String?

    @ViewBuilder
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title {
                Text(title).font(.headline)
            }
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
#endif
