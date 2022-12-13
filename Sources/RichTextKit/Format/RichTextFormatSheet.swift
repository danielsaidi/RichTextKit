//
//  RichTextFormatSheet.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This sheet view provides different text format options, and
 is meant to be used on iOS, where rich texts editor may not
 have enough space to present all formatting.

 Although the view is designed to be used on an iPhone, it's
 not excluded for the other platforms, although it will most
 probably feel off on them.

 Note that the topmost font list picker will take up as much
 height as it can, after the other rows have allocated their
 height. If you show this sheet with custom detents, do make
 sure that it has enough height to show a couple of fonts.
 */
public struct RichTextFormatSheet: View {

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

    public var body: some View {
        VStack(spacing: 0) {
            RichTextFontListPicker(selection: $context.fontName)
            Divider()
            VStack(spacing: 20) {
                HStack {
                    RichTextColorPickerStack(context: context)
                    Spacer()
                    RichTextFontSizePickerStack(context: context)
                }
                .prefersBordered()
                
                HStack {
                    RichTextStyleToggleStack(context: context)
                    RichTextAlignmentPicker(selection: $context.textAlignment)
                        .pickerStyle(.segmented)
                }
            }
            .padding()
            .accentColor(.primary)
            .background(background)
        }
    }
}

private extension RichTextFormatSheet {

    var background: some View {
        Color.clear
            .overlay(Color.primary.opacity(0.1))
            .shadow(color: .black.opacity(0.1), radius: 5)
            .edgesIgnoringSafeArea(.all)
    }
}

private extension View {

    @ViewBuilder
    func prefersBordered() -> some View {
        if #available(iOS 15.0, *) {
            self.buttonStyle(.bordered)
        } else {
            self
        }
    }
}

struct RichTextFormatSheet_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextFormatSheet(context: context)
        }
    }

    static var previews: some View {
        Preview()
    }
}
