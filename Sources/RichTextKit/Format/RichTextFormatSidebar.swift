//
//  RichTextFormatSidebar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/**
 This sidebar view provides various text format options, and
 is meant to be used on macOS, in a trailing sidebar.
 
 You can provide custom configurations to adjust the toolbar
 and style it by applying a `.richTextFormatToolbarStyle` to
 the view hierarchy.

 > Note: The sidebar is currently designed for macOS, but it
 should also be made to look good on iPadOS in landscape, to
 let us use it instead of the ``RichTextFormatSheet``.
 */
public struct RichTextFormatSidebar: RichTextFormatToolbarBase {

    /**
     Create a rich text format sheet.

     - Parameters:
       - context: The context to apply changes to.
       - config: The configuration to use, by default `.standard`.
     */
    public init(
        context: RichTextContext,
        config: Configuration = .standard
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.config = config
    }
    
    public typealias Configuration = RichTextFormatToolbar.Configuration

    @ObservedObject
    private var context: RichTextContext
    
    let config: Configuration

    @Environment(\.richTextFormatToolbarStyle)
    var style

    public var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            SidebarSection {
                fontPicker(value: $context.fontName)
                HStack {
                    styleToggleGroup(for: context)
                    Spacer()
                    fontSizePicker(for: context)
                }
            }
            
            Divider()

            SidebarSection {
                alignmentPicker(value: $context.textAlignment)
                HStack {
                    lineSpacingPicker(for: context)
                }
                HStack {
                    indentButtons(for: context, greedy: true)
                    superscriptButtons(for: context, greedy: true)
                }
            }
            
            Divider()

            if hasColorPickers {
                SidebarSection {
                    colorPickers(for: context)
                }
                .padding(.trailing, -8)
                Divider()
            }

            Spacer()
        }
        .padding(style.padding - 2)
        .background(Color.white.opacity(0.05))
    }
}

private struct SidebarSection<Content: View>: View {

    @ViewBuilder
    let content: () -> Content

    @Environment(\.richTextFormatToolbarStyle)
    var style
    
    var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            content()
        }
    }
}

struct RichTextFormatSidebar_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextFormatSidebar(
                context: context,
                config: .init(
                    alignments: [.left, .right],
                    colorPickers: [.foreground],
                    colorPickersDisclosed: [],
                    fontPicker: true,
                    fontSizePicker: true,
                    indentButtons: true,
                    styles: .all,
                    superscriptButtons: true
                )
            )
        }
    }

    static var previews: some View {
        Preview()
            .frame(minWidth: 350)
    }
}
#endif
