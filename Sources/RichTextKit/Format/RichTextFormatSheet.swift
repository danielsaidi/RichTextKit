//
//  RichTextFormatSheet.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-13.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import SwiftUI

/**
 This sheet view provides different text format options, and
 is meant to be used on iOS, where rich texts editor may not
 have enough space to present all formatting.

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

    @Environment(\.presentationMode)
    private var presentationMode

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                RichTextFontListPicker(selection: $context.fontName)
                Divider()
                VStack(spacing: 20) {
                    fontRow
                    paragraphRow
                    colorRow
                }
                .environment(\.sizeCategory, .medium)
                .padding()
                .accentColor(.primary)
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
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
    }
}

private extension RichTextFormatSheet {

    var colorRow: some View {
        HStack {
            Spacer()
            RichTextColorPickerStack(context: context)
        }
    }

    var fontRow: some View {
        HStack {
            styleButtons
            Spacer()
            RichTextFontSizePickerStack(context: context)
                .prefersBordered()
        }
    }

    var paragraphRow: some View {
        HStack {
            RichTextAlignmentPicker(selection: $context.textAlignment)
                .pickerStyle(.segmented)
            Spacer()
            indentButtons
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

    @ViewBuilder
    var indentButtons: some View {
        if #available(iOS 15.0, *) {
            RichTextActionButtonGroup(
                context: context,
                actions: [.decreaseIndent, .increaseIndent],
                greedy: false
            )
        } else {
            RichTextActionButtonStack(
                context: context,
                actions: [.decreaseIndent, .increaseIndent]
            ).prefersBordered()
        }
    }

    @ViewBuilder
    var styleButtons: some View {
        if #available(iOS 15.0, *) {
            RichTextStyleToggleGroup(
                context: context
            )
        } else {
            RichTextStyleToggleStack(
                context: context
            ).prefersBordered()
        }
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

    @ViewBuilder
    func withAutomaticToolbarRole() -> some View {
        if #available(iOS 16.0, *) {
            self.toolbarRole(.automatic)
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
#endif
