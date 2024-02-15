//
//  RichTextFormatSheet.swift
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

    @Environment(\.presentationMode)
    private var presentationMode

    /// The sheet padding.
    public var padding = 10.0

    /// The sheet top offset.
    public var topOffset = -35.0

    /// The configuration to use.
    private let config: Configuration

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                fontPicker
                VStack(spacing: padding) {
                    VStack {
                        fontRow
                        paragraphRow
                        Divider()
                    }.padding(.horizontal, padding)
                    VStack(spacing: padding) {
                        ForEach(config.colorPickers) {
                            RichTextColor.Picker(
                                type: $0,
                                value: context.binding(for: $0),
                                quickColors: .quickPickerColors
                            )
                        }
                    }.padding(.leading, padding)
                }
                .padding(.vertical, padding)
                .environment(\.sizeCategory, .medium)
                .background(background)
            }
            .withAutomaticToolbarRole()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EmptyView()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(RTKL10n.done.text) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

public extension RichTextFormatToolbar {
    
    /// This struct can be used to configure a format sheet.
    struct Configuration {
        
        public init(
            colorPickers: [RichTextColor] = [.foreground],
            fontPicker: Bool = true
        ) {
            self.colorPickers = colorPickers
            self.fontPicker = fontPicker
        }
        
        public var colorPickers: [RichTextColor]
        public var fontPicker: Bool
    }
}

public extension RichTextFormatToolbar.Configuration {
    
    /// The standard rich text format toolbar configuration.
    static var standard = Self.init()
}

private extension RichTextFormatToolbar {
    
    var background: some View {
        Color.clear
            .overlay(Color.primary.opacity(0.1))
            .shadow(color: .black.opacity(0.1), radius: 5)
            .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    var fontPicker: some View {
        if config.fontPicker {
            RichTextFont.ListPicker(selection: $context.fontName)
                .offset(y: topOffset)
                .padding(.bottom, topOffset)
            Divider()
        }
    }

    var fontRow: some View {
        HStack {
            styleButtons
            Spacer()
            RichTextFont.SizePickerStack(context: context)
                .buttonStyle(.bordered)
        }
    }
    
    @ViewBuilder
    var indentButtons: some View {
        RichTextAction.ButtonGroup(
            context: context,
            actions: [.decreaseIndent(), .increaseIndent()],
            greedy: false
        )
    }

    var paragraphRow: some View {
        HStack {
            RichTextAlignment.Picker(selection: $context.textAlignment)
                .pickerStyle(.segmented)
            Spacer()
            indentButtons
        }
    }
    
    @ViewBuilder
    var styleButtons: some View {
        RichTextStyle.ToggleGroup(
            context: context
        )
    }
}

private extension View {

    @ViewBuilder
    func withAutomaticToolbarRole() -> some View {
        if #available(iOS 16.0, *) {
            self.toolbarRole(.automatic)
        } else {
            self
        }
    }
}

struct RichTextFormatToolbar_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextFormatToolbar(
                context: context,
                config: .init(
                    colorPickers: [.foreground],
                    fontPicker: false
                )
            )
        }
    }

    static var previews: some View {
        Preview()
    }
}
