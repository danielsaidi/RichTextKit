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
public struct RichTextKeyboardToolbar<LeadingButtons: View, TrailingButtons: View, FormatSheet: View, ToolbarView: View>: View {
    
    /**
     Create a rich text keyboard toolbar.

     - Parameters:
       - context: The context to affect.
       - content: The toolbar content
     */
    public init(
        context: RichTextContext,
        style: RichTextKeyboardToolbarStyle = .standard,
        configuration: RichTextKeyboardToolbarConfiguration = .standard,
        actions: [RichTextAction] = [.undo, .redo, .copy],
        @ViewBuilder toolbarView: @escaping (([RichTextAction], RichTextKeyboardToolbarStyle) -> RichTextAction.ButtonStack, RichTextKeyboardToolbarStyle, () -> AnyView) -> ToolbarView
    ) where FormatSheet == RichTextFormatSheet, LeadingButtons == EmptyView, TrailingButtons == EmptyView {
        self.context = context
        self.leadingActions = actions
        self.trailingActions = []
        self.style = style
        self.configuration = configuration
        self.leadingButtons = { EmptyView() }
        self.trailingButtons = { EmptyView() }
        self.richTextFormatSheet = { $0 }
        self.toolbarView = toolbarView
    }
    
    

    /**
     Create a rich text keyboard toolbar.

     - Parameters:
       - context: The context to affect.
       - style: The toolbar style to apply, by default ``RichTextKeyboardToolbarStyle/standard``.
       - configuration: The view configuration, by default ``RichTextKeyboardToolbarConfiguration/standard``.
       - leadingActions: The leading actions, by default `.undo`, `.redo` and `.copy`.
       - trailingActions: The trailing actions, by default `.dismissKeyboard`.
       - leadingButtons: The leading buttons to place after the leading actions.
       - trailingButtons: The trailing buttons to place before the trailing actions.
       - richTextFormatSheet: The rich text format sheet to use, given the default ``RichTextFormatSheet``.
     */
    public init(
        context: RichTextContext,
        style: RichTextKeyboardToolbarStyle = .standard,
        configuration: RichTextKeyboardToolbarConfiguration = .standard,
        leadingActions: [RichTextAction] = [.undo, .redo, .copy],
        trailingActions: [RichTextAction] = [.dismissKeyboard],
        @ViewBuilder leadingButtons: @escaping () -> LeadingButtons,
        @ViewBuilder trailingButtons: @escaping () -> TrailingButtons,
        @ViewBuilder richTextFormatSheet: @escaping (RichTextFormatSheet) -> FormatSheet
    ) where ToolbarView == EmptyView {
        self._context = ObservedObject(wrappedValue: context)
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.style = style
        self.configuration = configuration
        self.leadingButtons = leadingButtons
        self.trailingButtons = trailingButtons
        self.richTextFormatSheet = richTextFormatSheet
        self.toolbarView = { _, _, _ in .init() }
    }

    /**
     Create a rich text keyboard toolbar.

     - Parameters:
       - context: The context to affect.
       - style: The toolbar style to apply, by default ``RichTextKeyboardToolbarStyle/standard``.
       - configuration: The view configuration, by default ``RichTextKeyboardToolbarConfiguration/standard``.
       - leadingActions: The leading actions, by default `.undo`, `.redo` and `.copy`.
       - trailingActions: The trailing actions, by default `.dismissKeyboard`.
       - leadingButtons: The leading buttons to place after the leading actions.
       - trailingButtons: The trailing buttons to place after the trailing actions.
       - richTextFormatSheet: The rich text format sheet to use, given the default ``RichTextFormatSheet``.
     */
    public init(
        context: RichTextContext,
        style: RichTextKeyboardToolbarStyle = .standard,
        configuration: RichTextKeyboardToolbarConfiguration = .standard,
        leadingActions: [RichTextAction] = [.undo, .redo, .copy],
        trailingActions: [RichTextAction] = [.dismissKeyboard],
        @ViewBuilder leadingButtons: @escaping () -> LeadingButtons,
        @ViewBuilder trailingButtons: @escaping () -> TrailingButtons
    ) where FormatSheet == RichTextFormatSheet, ToolbarView == EmptyView {
        self.init(
            context: context,
            style: style,
            configuration: configuration,
            leadingActions: leadingActions,
            trailingActions: trailingActions,
            leadingButtons: leadingButtons,
            trailingButtons: trailingButtons,
            richTextFormatSheet: { $0 }
        )
    }

    private let leadingActions: [RichTextAction]
    private let trailingActions: [RichTextAction]
    private let style: RichTextKeyboardToolbarStyle
    private let configuration: RichTextKeyboardToolbarConfiguration

    private let leadingButtons: () -> LeadingButtons
    private let trailingButtons: () -> TrailingButtons
    private let richTextFormatSheet: (RichTextFormatSheet) -> FormatSheet
    
    private let toolbarView: (([RichTextAction], RichTextKeyboardToolbarStyle) -> RichTextAction.ButtonStack, RichTextKeyboardToolbarStyle, () -> AnyView) -> ToolbarView

    @ObservedObject
    private var context: RichTextContext

    @State
    private var isFormatSheetPresented = false

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    public var body: some View {
        VStack(spacing: 0) {
            toolbar
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
            richTextFormatSheet(
                RichTextFormatSheet(context: context)
            ).prefersMediumSize()
        }
    }
}

extension RichTextKeyboardToolbar where ToolbarView == EmptyView {
    @ViewBuilder
    private var toolbar: some View {
        HStack(spacing: style.itemSpacing) {
            leadingViews
            Spacer()
            trailingViews
        }
    }
}

extension RichTextKeyboardToolbar {
    @ViewBuilder
    private var toolbar: some View {
        toolbarView(
            actionsButtonStack,
            style,
            { AnyView(erasing: richTextButton()) }
        )
        .frame(maxWidth: .infinity)
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
    func richTextButton() -> some View {
        Button(action: presentFormatSheet) {
            Image.richTextFormat
                .contentShape(Rectangle())
        }
    }
    
    @ViewBuilder
    func actionsButtonStack(
        actions: [RichTextAction],
        style: RichTextKeyboardToolbarStyle
    ) -> RichTextAction.ButtonStack {
        RichTextAction.ButtonStack(
            context: context,
            actions: actions,
            spacing: style.itemSpacing
        )
    }

    @ViewBuilder
    var leadingViews: some View {
        actionsButtonStack(
            actions: leadingActions,
            style: style
        )

        leadingButtons()

        divider

        richTextButton()

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

private extension RichTextKeyboardToolbar {

    var shouldDisplayToolbar: Bool { context.isEditingText || configuration.alwaysDisplayToolbar }
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

/**
 This can be used to style a ``RichTextKeyboardToolbar``.
 */
public struct RichTextKeyboardToolbarStyle {

    /**
     Create a custom toolbar style.

     - Parameters:
       - toolbarHeight: The height of the toolbar, by default `50`.
       - itemSpacing: The spacing between toolbar items, by default `15`.
       - shadowColor: The toolbar's shadow color, by default transparent black.
       - shadowRadius: The toolbar's shadow radius, by default `3`.

     */
    public init(
        toolbarHeight: Double = 50,
        itemSpacing: Double = 15,
        shadowColor: Color = .black.opacity(0.1),
        shadowRadius: Double = 3
    ) {
        self.toolbarHeight = toolbarHeight
        self.itemSpacing = itemSpacing
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
    }

    /// The height of the toolbar.
    public var toolbarHeight: Double

    /// The spacing between toolbar items.
    public var itemSpacing: Double

    /// The toolbar's shadow color.
    public var shadowColor: Color

    /// The toolbar's shadow radius.
    public var shadowRadius: Double
}

public extension RichTextKeyboardToolbarStyle {

    /// This standard style is used by default.
    static var standard = RichTextKeyboardToolbarStyle()
}

/**
 This can be used to configure a ``RichTextKeyboardToolbar``.
 */
public struct RichTextKeyboardToolbarConfiguration {
    /**
     Create a custom toolbar configuration.

     - Parameters:
       - alwaysDisplayToolbar: Should toolbar always be displayed, by default is `false`.
     */
    public init(
        alwaysDisplayToolbar: Bool = false
    ) {
        self.alwaysDisplayToolbar = alwaysDisplayToolbar
    }

    /// Should the toolbar always be displayed.
    public var alwaysDisplayToolbar: Bool
}

public extension RichTextKeyboardToolbarConfiguration {

    /// This standard configuration is used by default.
    static var standard = RichTextKeyboardToolbarConfiguration()
}

private extension RichTextKeyboardToolbar {

    func presentFormatSheet() {
        isFormatSheetPresented = true
    }
}

struct RichTextKeyboardToolbar_Previews: PreviewProvider {
    
    struct LeadingAndTrailingPreview: View {

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

    struct FlexbileToolbar: View {

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
                    context: context
                ) { actionsButtonStack, style, richTextButton in
                    HStack {
                        actionsButtonStack(
                            [
                                .toggleStyle(.bold),
                                .toggleStyle(.italic),
                                .toggleStyle(.underlined)
                            ],
                            style
                        )
                            .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        richTextButton()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    static var previews: some View {
        Group {
            LeadingAndTrailingPreview()
                .previewDisplayName("Leading and Trailing")
            
            FlexbileToolbar()
                .previewDisplayName("Flexible")
        }
    }
}
#endif
