//
//  RichTextFormat+Sidebar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormat {

    /// This view has various format options and is meant to be used on macOS,
    /// in a trailing sidebar.
    ///
    /// You can style and configure this view by applying the view modifiers
    /// ``SwiftUICore/View/richTextFormatSidebarStyle(_:)`` and
    /// ``SwiftUICore/View/richTextFormatSidebarConfig(_:)``.
    ///
    /// > Note: This sidebar is currently designed for macOS, but should also be
    /// made to look good on iPadOS in landscape.
    struct Sidebar: RichTextFormatToolbarBase {

        /// Create a rich text format sheet.
        ///
        /// - Parameters:
        ///   - context: The context to apply changes to.
        public init(
            context: RichTextContext
        ) {
            self._context = ObservedObject(wrappedValue: context)
        }

        public typealias Config = RichTextFormat.ToolbarConfig
        public typealias Style = RichTextFormat.ToolbarStyle

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
                    alignmentPicker(for: context)

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
            .labelsHidden()
            .padding(style.padding - 2)
            .background(Color.white.opacity(0.05))
        }
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
        _ value: RichTextFormat.Sidebar.Config
    ) -> some View {
        self.environment(\.richTextFormatSidebarConfig, value)
    }

    /// Apply a rich text format sidebar style.
    func richTextFormatSidebarStyle(
        _ value: RichTextFormat.Sidebar.Style
    ) -> some View {
        self.environment(\.richTextFormatSidebarStyle, value)
    }
}

private extension RichTextFormat.Sidebar.Config {

    struct Key: EnvironmentKey {

        static var defaultValue: RichTextFormat.Sidebar.Config {
            .standard
        }
    }
}

private extension RichTextFormat.Sidebar.Style {

    struct Key: EnvironmentKey {

        static var defaultValue: RichTextFormat.Sidebar.Style {
            .standard
        }
    }
}

public extension EnvironmentValues {

    /// This value can bind to a format sidebar config.
    var richTextFormatSidebarConfig: RichTextFormat.Sidebar.Config {
        get { self [RichTextFormat.Sidebar.Config.Key.self] }
        set { self [RichTextFormat.Sidebar.Config.Key.self] = newValue }
    }

    /// This value can bind to a format sidebar style.
    var richTextFormatSidebarStyle: RichTextFormat.Sidebar.Style {
        get { self [RichTextFormat.Sidebar.Style.Key.self] }
        set { self [RichTextFormat.Sidebar.Style.Key.self] = newValue }
    }
}

#Preview {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextFormat.Sidebar(
                context: context
            )
            .richTextFormatSidebarConfig(.init(
                alignments: [.left, .right],
                colorPickers: [.foreground],
                colorPickersDisclosed: [.background],
                fontPicker: false,
                fontSizePicker: true,
                indentButtons: true,
                styles: .all,
                superscriptButtons: true
            ))
        }
    }

    return Preview()
}
#endif
