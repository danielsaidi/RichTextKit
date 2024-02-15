//
//  RichTextFormatToolbar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This toolbar provides different text format options, and is
 meant to be used on iOS, where space is limited.
 
 Consider presenting this view from the bottom in a way that
 doesn't cause the underlying text view to dim.
 
 You can provide a custom configuration to adjust the format
 options that are presented. When presented, the font picker
 will take up the available vertical height.
 
 You can style this view by applying a style anywhere in the
 view hierarchy, using `.richTextFormatToolbarStyle`.
 */
public struct RichTextFormatToolbar: View {

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
    
    @Environment(\.richTextFormatToolbarStyle)
    private var style
    
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    /// The configuration to use.
    private let config: Configuration

    public var body: some View {
        VStack(spacing: 0) {
            fontPicker
            toolbar
        }
    }
}


// MARK: - Configuration

public extension RichTextFormatToolbar {
    
    /// This struct can be used to configure a format sheet.
    struct Configuration {
        
        public init(
            alignments: [RichTextAlignment] = .all,
            colorPickers: [RichTextColor] = [.foreground],
            fontPicker: Bool = true,
            fontSizePicker: Bool = true,
            indentButtons: Bool = true,
            styles: [RichTextStyle] = .all,
            superscriptButtons: Bool = true
        ) {
            self.alignments = alignments
            self.colorPickers = colorPickers
            self.fontPicker = fontPicker
            self.fontSizePicker = fontSizePicker
            self.indentButtons = indentButtons
            self.styles = styles
            #if macOS
            self.superscriptButtons = superscriptButtons
            #else
            self.superscriptButtons = false
            #endif
        }
        
        public var alignments: [RichTextAlignment]
        public var colorPickers: [RichTextColor]
        public var fontPicker: Bool
        public var fontSizePicker: Bool
        public var indentButtons: Bool
        public var styles: [RichTextStyle]
        public var superscriptButtons: Bool
    }
}

public extension RichTextFormatToolbar.Configuration {
    
    /// The standard rich text format toolbar configuration.
    static var standard = Self.init()
}


// MARK: - Style

public extension RichTextFormatToolbar {
    
    /// This struct can be used to style a format sheet.
    ///
    /// Don't specify a font picker height if the toolbar is
    /// presented in a sheet. In those cases, use detents to
    /// limit its height.
    struct Style {
        
        public init(
            fontPickerHeight: CGFloat? = nil,
            padding: Double = 10,
            spacing: Double = 10
        ) {
            self.fontPickerHeight = fontPickerHeight
            self.padding = padding
            self.spacing = spacing
        }
        
        public var fontPickerHeight: CGFloat?
        public var padding: Double
        public var spacing: Double
    }
    
    /// This environment key defines a format toolbar style.
    struct StyleKey: EnvironmentKey {
        
        public static let defaultValue = RichTextFormatToolbar.Style()
    }
}

public extension View {
    
    /// Apply a rich text format toolbar style.
    func richTextFormatToolbarStyle(
        _ style: RichTextFormatToolbar.Style
    ) -> some View {
        self.environment(\.richTextFormatToolbarStyle, style)
    }
}

public extension EnvironmentValues {
    
    /// This environment value defines format toolbar styles.
    var richTextFormatToolbarStyle: RichTextFormatToolbar.Style {
        get { self [RichTextFormatToolbar.StyleKey.self] }
        set { self [RichTextFormatToolbar.StyleKey.self] = newValue }
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
    
    @ViewBuilder
    var fontPicker: some View {
        if config.fontPicker {
            RichTextFont.ListPicker(selection: $context.fontName)
                .frame(height: style.fontPickerHeight)
            Divider()
        }
    }
    
    var toolbar: some View {
        VStack(spacing: style.spacing) {
            controls
            colorPickers
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
    
    @ViewBuilder
    var alignmentPicker: some View {
        if !config.alignments.isEmpty {
            RichTextAlignment.Picker(
                selection: $context.textAlignment,
                values: config.alignments
            )
            .pickerStyle(.segmented)
        }
    }
    
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
            styleButtons
            fontSizePicker
            if horizontalSizeClass == .regular {
                Spacer()
            }
        }
        HStack {
            alignmentPicker
            superscriptButtons
            indentButtons
        }
    }
    
    @ViewBuilder
    var colorPickers: some View {
        if !config.colorPickers.isEmpty {
            VStack(spacing: style.spacing) {
                Divider()
                ForEach(config.colorPickers) {
                    RichTextColor.Picker(
                        type: $0,
                        value: context.binding(for: $0),
                        quickColors: .quickPickerColors
                    )
                }
            }
            .padding(.leading, style.padding)
        }
    }
    
    @ViewBuilder
    var fontSizePicker: some View {
        if config.fontSizePicker {
            RichTextFont.SizePickerStack(context: context)
                .buttonStyle(.bordered)
        }
    }
    
    @ViewBuilder
    var indentButtons: some View {
        if config.indentButtons {
            RichTextAction.ButtonGroup(
                context: context,
                actions: [.decreaseIndent(), .increaseIndent()],
                greedy: false
            )
        }
    }
    
    @ViewBuilder
    var styleButtons: some View {
        if !config.styles.isEmpty {
            RichTextStyle.ToggleGroup(
                context: context,
                styles: config.styles
            )
            if !useSingleLine {
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    var superscriptButtons: some View {
        if config.superscriptButtons {
            RichTextAction.ButtonGroup(
                context: context,
                actions: [.decreaseSuperscript(), .increaseSuperscript()],
                greedy: false
            )
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
                    // colorPickers: [.foreground],
                    fontPicker: false,
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
