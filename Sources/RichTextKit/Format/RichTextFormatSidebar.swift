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
 
 You can configure and style the view by applying its config
 and style view modifiers to your view hierarchy:
 
 ```swift
 VStack {
    ...
 }
 .richTextFormatSidebarStyle(...)
 .richTextFormatSidebarConfig(...)
 ```

 > Note: The sidebar is currently designed for macOS, but it
 should also be made to look good on iPadOS in landscape, to
 let us use it instead of the ``RichTextFormatSheet``.
 */
public struct RichTextFormatSidebar: RichTextFormatToolbarBase {

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

    public typealias Config = RichTextFormatToolbar.Config
    public typealias Style = RichTextFormatToolbar.Style

    @ObservedObject
    private var context: RichTextContext
    
    @Environment(\.richTextFormatSidebarConfig)
    var config
    
    @Environment(\.richTextFormatSidebarStyle)
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

public extension View {
    
    /// Apply a rich text format sidebar config.
    func richTextFormatSidebarConfig(
        _ value: RichTextFormatSidebar.Config
    ) -> some View {
        self.environment(\.richTextFormatSidebarConfig, value)
    }
    
    /// Apply a rich text format sidebar style.
    func richTextFormatSidebarStyle(
        _ value: RichTextFormatSidebar.Style
    ) -> some View {
        self.environment(\.richTextFormatSidebarStyle, value)
    }
}

private extension RichTextFormatSidebar.Config {

    struct Key: EnvironmentKey {

        static let defaultValue = RichTextFormatSidebar.Config()
    }
}

private extension RichTextFormatSidebar.Style {

    struct Key: EnvironmentKey {

        static let defaultValue = RichTextFormatSidebar.Style()
    }
}

public extension EnvironmentValues {
    
    /// This value can bind to a format sidebar config.
    var richTextFormatSidebarConfig: RichTextFormatSidebar.Config {
        get { self [RichTextFormatSidebar.Config.Key.self] }
        set { self [RichTextFormatSidebar.Config.Key.self] = newValue }
    }
    
    /// This value can bind to a format sidebar style.
    var richTextFormatSidebarStyle: RichTextFormatSidebar.Style {
        get { self [RichTextFormatSidebar.Style.Key.self] }
        set { self [RichTextFormatSidebar.Style.Key.self] = newValue }
    }
}

struct RichTextFormatSidebar_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextFormatSidebar(
                context: context
            )
            .richTextFormatSidebarConfig(.init(
                alignments: [.left, .right],
                colorPickers: [.foreground],
                colorPickersDisclosed: [],
                fontPicker: false,
                fontSizePicker: true,
                indentButtons: true,
                styles: .all,
                superscriptButtons: true
            ))
        }
    }

    static var previews: some View {
        Preview()
            .frame(minWidth: 350)
    }
}
#endif
