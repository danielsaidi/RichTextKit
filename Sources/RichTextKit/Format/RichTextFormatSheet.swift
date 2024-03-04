//
//  RichTextFormatSheet.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/**
 This sheet contains a font list picker and a bottom toolbar.

 You can configure and style the view by applying its config
 and style view modifiers to your view hierarchy:
 
 ```swift
 VStack {
    ...
 }
 .richTextFormatSheetStyle(...)
 .richTextFormatSheetConfig(...)
 ```
 */
public struct RichTextFormatSheet: RichTextFormatToolbarBase {

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

    @Environment(\.richTextFormatSheetConfig)
    var config
    
    @Environment(\.richTextFormatSheetStyle)
    var style

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                RichTextFont.ListPicker(
                    selection: $context.fontName
                )
                Divider()
                RichTextFormatToolbar(
                    context: context
                )
                .richTextFormatToolbarConfig(config)
            }
            .padding(.top, -35)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(RTKL10n.done.text) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("")
            #if iOS
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        #if iOS
        .navigationViewStyle(.stack)
        #endif
    }
}

public extension View {
    
    /// Apply a rich text format sheet config.
    func richTextFormatSheetConfig(
        _ value: RichTextFormatSheet.Config
    ) -> some View {
        self.environment(\.richTextFormatSheetConfig, value)
    }
    
    /// Apply a rich text format sheet style.
    func richTextFormatSheetStyle(
        _ value: RichTextFormatSheet.Style
    ) -> some View {
        self.environment(\.richTextFormatSheetStyle, value)
    }
}

private extension RichTextFormatSheet.Config {

    struct Key: EnvironmentKey {

        static let defaultValue = RichTextFormatSheet.Config()
    }
}

private extension RichTextFormatSheet.Style {

    struct Key: EnvironmentKey {

        static let defaultValue = RichTextFormatSheet.Style()
    }
}

public extension EnvironmentValues {
    
    /// This value can bind to a format sheet config.
    var richTextFormatSheetConfig: RichTextFormatSheet.Config {
        get { self [RichTextFormatSheet.Config.Key.self] }
        set { self [RichTextFormatSheet.Config.Key.self] = newValue }
    }
    
    /// This value can bind to a format sheet style.
    var richTextFormatSheetStyle: RichTextFormatSheet.Style {
        get { self [RichTextFormatSheet.Style.Key.self] }
        set { self [RichTextFormatSheet.Style.Key.self] = newValue }
    }
}

struct RichTextFormatSheet_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        @State
        private var isSheetPresented = false

        var body: some View {
            VStack(spacing: 0) {
                Color.red
                Button("Toggle sheet") {
                    isSheetPresented.toggle()
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                RichTextFormatSheet(
                    context: context
                )
                .richTextFormatSheetConfig(.init(
                    alignments: .all,
                    colorPickers: [.foreground, .background],
                    colorPickersDisclosed: [.stroke],
                    fontPicker: true,
                    fontSizePicker: false,
                    indentButtons: true,
                    styles: .all
                ))
            }
            .richTextFormatToolbarStyle(.init(
                padding: 10,
                spacing: 10
            ))
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
