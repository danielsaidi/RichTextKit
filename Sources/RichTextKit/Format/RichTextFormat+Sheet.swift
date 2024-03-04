//
//  RichTextFormat+Sheet.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormat {
    
    /**
     This sheet contains a font picker and a bottom toolbar.
     
     You can configure and style the view by applying config
     and style view modifiers to your view hierarchy:
     
     ```swift
     VStack {
     ...
     }
     .richTextFormatSheetStyle(...)
     .richTextFormatSheetConfig(...)
     ```
     */
    struct Sheet: RichTextFormatToolbarBase {
        
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
}

public extension View {
    
    /// Apply a rich text format sheet config.
    func richTextFormatSheetConfig(
        _ value: RichTextFormat.Sheet.Config
    ) -> some View {
        self.environment(\.richTextFormatSheetConfig, value)
    }
    
    /// Apply a rich text format sheet style.
    func richTextFormatSheetStyle(
        _ value: RichTextFormat.Sheet.Style
    ) -> some View {
        self.environment(\.richTextFormatSheetStyle, value)
    }
}

private extension RichTextFormat.Sheet.Config {

    struct Key: EnvironmentKey {

        static let defaultValue = RichTextFormat.Sheet.Config()
    }
}

private extension RichTextFormat.Sheet.Style {

    struct Key: EnvironmentKey {

        static let defaultValue = RichTextFormat.Sheet.Style()
    }
}

public extension EnvironmentValues {
    
    /// This value can bind to a format sheet config.
    var richTextFormatSheetConfig: RichTextFormat.Sheet.Config {
        get { self [RichTextFormat.Sheet.Config.Key.self] }
        set { self [RichTextFormat.Sheet.Config.Key.self] = newValue }
    }
    
    /// This value can bind to a format sheet style.
    var richTextFormatSheetStyle: RichTextFormat.Sheet.Style {
        get { self [RichTextFormat.Sheet.Style.Key.self] }
        set { self [RichTextFormat.Sheet.Style.Key.self] = newValue }
    }
}

struct RichTextFormat_Sheet_Previews: PreviewProvider {

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
                RichTextFormat.Sheet(
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
