//
//  RichTextKeyboardToolbar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-14.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

/**
 This toolbar can be added above the iOS keyboard to make it
 easy to provide rich text formatting in a very compact form.

 This view has customizable actions and also supports adding
 custom leading and trailing buttons. It shows more views if
 the horizontal size class is regular.

 This custom toolbar is needed since ``RichTextEditor`` will
 wrap a native `UIKit` text view, which means that using the
 `toolbar` modifier with a `keyboard` placement doesn't work:

 ```swift
 RichTextEditor(text: $text, context: context)
     .toolbar {
         ToolbarItemGroup(placement: .keyboard) {
             ....
         }
     }
 ```

 The above code will simply not show anything when you start
 to edit text. To work around this limitation, you can use a
 this custom toolbar instead, which by default will show and
 hide itself as you begin and end editing the text.
 */
public struct RichTextKeyboardToolbar<LeadingButtons: View, TrailingButtons: View, FormatSheet: View>: View {

    /**
     Create a rich text keyboard toolbar.

     - Parameters:
       - context: The context to affect.
       - leadingActions: The leading actions, by default `.undo`, `.redo` and `.copy`.
       - trailingActions: The trailing actions, by default `.dismissKeyboard`.
       - leadingButtons: The leading buttons to place after the leading actions.
       - trailingButtons: The trailing buttons to place before the trailing actions.
       - formatSheet: The rich text format sheet to use, given the default ``RichTextFormatSheet``.
     */
    public init(
        context: RichTextContext,
        leadingActions: [RichTextAction] = [.undo, .redo],
        trailingActions: [RichTextAction] = [.dismissKeyboard],
        @ViewBuilder leadingButtons: @escaping () -> LeadingButtons,
        @ViewBuilder trailingButtons: @escaping () -> TrailingButtons,
        @ViewBuilder formatSheet: @escaping (RichTextFormatSheet) -> FormatSheet
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.leadingButtons = leadingButtons
        self.trailingButtons = trailingButtons
        self.formatSheet = formatSheet
    }

    private let leadingActions: [RichTextAction]
    private let trailingActions: [RichTextAction]

    private let leadingButtons: () -> LeadingButtons
    private let trailingButtons: () -> TrailingButtons
    private let formatSheet: (RichTextFormatSheet) -> FormatSheet

    @ObservedObject
    private var context: RichTextContext

    @State
    private var isFormatSheetPresented = false

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    @Environment(\.richTextKeyboardToolbarConfiguration)
    var configuration

    @Environment(\.richTextKeyboardToolbarStyle)
    var style

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: style.itemSpacing) {
                leadingViews
                Spacer()
                trailingViews
            }
            .padding(10)
        }
        .environment(\.sizeCategory, .medium)
        .frame(height: style.toolbarHeight)
        .overlay(Divider(), alignment: .bottom)
        .accentColor(.primary)
        .background(
            Color.primary.colorInvert()
                .overlay(Color.white.opacity(0.2))
                .shadow(color: style.shadowColor, radius: style.shadowRadius, x: 0, y: 0)
        )
        .opacity(shouldDisplayToolbar ? 1 : 0)
        .offset(y: shouldDisplayToolbar ? 0 : style.toolbarHeight)
        .frame(height: shouldDisplayToolbar ? nil : 0)
        .sheet(isPresented: $isFormatSheetPresented) {
            formatSheet(
                RichTextFormatSheet(context: context)
            ).prefersMediumSize()
        }
    }
}

private extension View {

    @ViewBuilder
    func prefersMediumSize() -> some View {
        #if macOS
        self
        #else
        if #available(iOS 16, *) {
            self.presentationDetents([.medium])
        } else {
            self
        }
        #endif
    }
}

private extension RichTextKeyboardToolbar {

    var isCompact: Bool {
        horizontalSizeClass == .compact
    }
}

private extension RichTextKeyboardToolbar {

    var divider: some View {
        Divider()
            .frame(height: 25)
    }

    @ViewBuilder
    var leadingViews: some View {
        RichTextAction.ButtonStack(
            context: context,
            actions: leadingActions,
            spacing: style.itemSpacing
        )

        leadingButtons()

        divider

        Button(action: presentFormatSheet) {
            Image.richTextFormat
                .contentShape(Rectangle())
        }

        RichTextStyle.ToggleStack(context: context)
            .keyboardShortcutsOnly(if: isCompact)

        RichTextFont.SizePickerStack(context: context)
            .keyboardShortcutsOnly()
    }

    @ViewBuilder
    var trailingViews: some View {
        RichTextAlignment.Picker(selection: $context.textAlignment)
            .pickerStyle(.segmented)
            .frame(maxWidth: 200)
            .keyboardShortcutsOnly(if: isCompact)

        trailingButtons()

        RichTextAction.ButtonStack(
            context: context,
            actions: trailingActions,
            spacing: style.itemSpacing
        )
    }
}

private extension View {

    @ViewBuilder
    func keyboardShortcutsOnly(
        if condition: Bool = true
    ) -> some View {
        if condition {
            self.hidden()
                .frame(width: 0)
        } else {
            self
        }
    }
}

private extension RichTextKeyboardToolbar {

    var shouldDisplayToolbar: Bool { context.isEditingText || configuration.alwaysDisplayToolbar }
}

private extension RichTextKeyboardToolbar {

    func presentFormatSheet() {
        isFormatSheetPresented = true
    }
}

struct RichTextKeyboardToolbar_Previews: PreviewProvider {

    struct Preview: View {

        @State
        private var text = NSAttributedString(string: "")

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            VStack(spacing: 0) {
                RichTextEditor(text: $text, context: context)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    .background(Color.gray.ignoresSafeArea())
                RichTextKeyboardToolbar(
                    context: context,
                    leadingButtons: {},
                    trailingButtons: {},
                    formatSheet: { $0 }
                )
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
