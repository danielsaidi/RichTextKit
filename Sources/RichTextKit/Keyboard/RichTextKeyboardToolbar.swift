//
//  RichTextKeyboardToolbar.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-14.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import SwiftUI

/**
 This toolbar can be added above the iOS keyboard to make it
 easy to provide rich text formatting in a very compact form.

 This view has customizable actions and also supports adding
 custom leading and trailing buttons. It shows more views if
 the horizontal size class is regular.
 */
public struct RichTextKeyboardToolbar<LeadingButtons: View, TrailingButtons: View>: View {

    /**
     Create a rich text keyboard toolbar.

     - Parameters:
       - context: The context to affect.
       - leadingActions: The leading actions, by default `.undo`, `.redo` and `.copy`.
       - trailingActions: The trailing actions, by default `.dismissKeyboard`.
       - spacing: The stack item spacing, by default `15`.
       - height: The toolbar height, by default `50`.
       - style: The toolbar style to apply, by default ``RichTextKeyboardToolbar/Style/standard``.
       - leadingButtons: The leading buttons to place after the leading actions.
       - trailingButtons: The trailing buttons to place after the trailing actions.
     */
    public init(
        context: RichTextContext,
        leadingActions: [RichTextAction] = [.undo, .redo, .copy],
        trailingActions: [RichTextAction] = [.dismissKeyboard],
        spacing: Double = 15,
        height: Double = 50,
        style: RichTextKeyboardToolbarStyle = .standard,
        @ViewBuilder leadingButtons: @escaping () -> LeadingButtons,
        @ViewBuilder trailingButtons: @escaping () -> TrailingButtons
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.spacing = spacing
        self.height = height
        self.style = style
        self.leadingButtons = leadingButtons
        self.trailingButtons = trailingButtons
    }

    private let leadingActions: [RichTextAction]
    private let trailingActions: [RichTextAction]
    private let spacing: Double
    private let height: Double
    private let style: RichTextKeyboardToolbarStyle

    private let leadingButtons: () -> LeadingButtons
    private let trailingButtons: () -> TrailingButtons

    @ObservedObject
    private var context: RichTextContext

    @State
    private var isSheetPresented = false

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: spacing) {
                leadingViews
                Spacer()
                trailingViews
            }
            .padding(10)
        }
        .frame(height: height)
        .overlay(Divider(), alignment: .bottom)
        .accentColor(.primary)
        .background(
            Color.primary.colorInvert()
                .overlay(Color.white.opacity(0.2))
                .shadow(color: style.shadowColor, radius: style.shadowRadius, x: 0, y: 0)
        )
        .opacity(context.isEditingText ? 1 : 0)
        .offset(y: context.isEditingText ? 0 : height)
        .frame(height: context.isEditingText ? nil : 0)
        .sheet(isPresented: $isSheetPresented) {
            RichTextFormatSheet(context: context)
        }
    }
}

private extension RichTextKeyboardToolbar {

    var isCompact: Bool { horizontalSizeClass == .compact }
}

private extension RichTextKeyboardToolbar {

    var divider: some View {
        Divider().frame(height: 25)
    }

    @ViewBuilder
    var leadingViews: some View {
        RichTextActionButtonStack(
            context: context,
            actions: leadingActions,
            spacing: spacing
        )

        leadingButtons()

        divider

        Button(action: presentFormatSheet) {
            Image.richTextFormat
                .contentShape(Rectangle())
        }

        RichTextStyleToggleStack(context: context)
            .hidden(if: isCompact)
        RichTextFontSizePickerStack(context: context)
            .hidden(if: isCompact)
    }

    @ViewBuilder
    var trailingViews: some View {
        RichTextAlignmentPicker(selection: $context.textAlignment)
            .pickerStyle(.segmented)
            .frame(maxWidth: 200)
            .hidden(if: isCompact)

        trailingButtons()

        RichTextActionButtonStack(
            context: context,
            actions: trailingActions,
            spacing: spacing
        )
    }
}

private extension View {

    @ViewBuilder
    func hidden(if condition: Bool) -> some View {
        if condition {
            self.hidden()
        } else {
            self
        }
    }
}

/**
 This can be used to style a ``RichTextKeyboardToolbar``.
 */
public struct RichTextKeyboardToolbarStyle {

    /**
     Create a custom toolbar style.

     - Parameters:
       - shadowColor: The toolbar's shadow color, by default transparent black.
       - shadowRadius: The toolbar's shadow radius, by default `3`.
     */
    public init(
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: Double = 3
    ) {
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }

    /// The toolbar's shadow color.
    public var shadowColor: Color

    /// The toolbar's shadow radius.
    public var shadowRadius: Double
}

public extension RichTextKeyboardToolbarStyle {

    /// This standard style is used by default.
    static var standard = RichTextKeyboardToolbarStyle()
}

private extension RichTextKeyboardToolbar {

    func presentFormatSheet() {
        isSheetPresented = true
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
                    trailingButtons: {}
                )
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
