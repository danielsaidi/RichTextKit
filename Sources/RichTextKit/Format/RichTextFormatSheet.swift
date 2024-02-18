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

 You can inject a custom toolbar configuration to adjust the
 toolbar. The font picker will take up all available height.

 You can style this view by applying a style anywhere in the
 view hierarchy, using `.richTextFormatToolbarStyle`.
 */
public struct RichTextFormatSheet: RichTextFormatToolbarBase {

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
                    context: context,
                    config: config
                )
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
                    context: context,
                    config: .init(
                        alignments: .all,
                        colorPickers: [.foreground, .background],
                        colorPickersDisclosed: [.stroke],
                        fontPicker: true,
                        fontSizePicker: true,
                        indentButtons: true,
                        styles: .all
                    )
                )
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
