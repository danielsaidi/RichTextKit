//
//  RichTextFormatToolbar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/**
 This horizontal toolbar provides text format controls.
 
 This toolbar adapts the layout based on the horizontal size
 class. The control row will be split in two in compact size,
 while macOS and regular sizes get a single row.
 
 You can provide a custom configuration to adjust the format
 options. The font picker will take up all available height.
 
 You can style this view by applying a style anywhere in the
 view hierarchy, using `.richTextFormatToolbarStyle`.
 */
public struct RichTextFormatToolbar: RichTextFormatToolbarBase {

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

    @ObservedObject
    private var context: RichTextContext
    
    let config: Configuration
    
    @Environment(\.richTextFormatToolbarStyle)
    var style
    
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    public var body: some View {
        VStack(spacing: 0) {
            fontListPicker(value: $context.fontName)
            toolbar
        }
    }
}


#if iOS
// MARK: - Sheet

public extension RichTextFormatToolbar {
    
    /// Convert the toolbar to a sheet, with a close button.
    func asSheet(
        dismiss: @escaping () -> Void
    ) -> some View {
        NavigationView {
            self
                .padding(.top, -35)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(RTKL10n.done.text, action: dismiss)
                    }
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}
#endif


// MARK: - Views

private extension RichTextFormatToolbar {
    
    var toolbar: some View {
        VStack(spacing: style.spacing) {
            controls
            if hasColorPickers {
                Divider()
                colorPickers(for: context)
            }
        }
        .padding(.vertical, style.padding)
        .environment(\.sizeCategory, .medium)
        .background(background)
    }
    
    var useSingleLine: Bool {
        #if macOS
        true
        #else
        horizontalSizeClass == .regular
        #endif
    }
}

private extension RichTextFormatToolbar {
    
    var background: some View {
        Color.clear
            .overlay(Color.primary.opacity(0.1))
            .shadow(color: .black.opacity(0.1), radius: 5)
            .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    var controls: some View {
        if useSingleLine {
            HStack {
                controlsContent
            }
            .padding(.horizontal, style.padding)
        } else {
            VStack(spacing: style.spacing) {
                controlsContent
            }
            .padding(.horizontal, style.padding)
        }
    }
    
    @ViewBuilder
    var controlsContent: some View {
        HStack {
            styleToggleGroup(for: context)
            if !useSingleLine {
                Spacer()
            }
            fontSizePicker(for: context)
            if horizontalSizeClass == .regular {
                Spacer()
            }
        }
        HStack {
            alignmentPicker(value: $context.textAlignment)
            superscriptButtons(for: context, greedy: false)
            indentButtons(for: context, greedy: false)
        }
    }
}

struct RichTextFormatToolbar_Previews: PreviewProvider {

    struct Preview: View {
        
        @StateObject
        private var context = RichTextContext()

        @State
        private var isSheetPresented = false
        
        var toolbar: RichTextFormatToolbar {
            .init(
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
        
        var body: some View {
            VStack(spacing: 0) {
                Color.red
                Button("Toggle sheet") {
                    isSheetPresented.toggle()
                }
                toolbar
            }
            .sheet(isPresented: $isSheetPresented) {
                toolbar
                    #if iOS
                    .asSheet { isSheetPresented = false }
                    #endif
                    .richTextFormatToolbarStyle(.init(
                        fontPickerHeight: nil
                    ))
            }
            .richTextFormatToolbarStyle(.init(
                fontPickerHeight: 100,
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
