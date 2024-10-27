//
//  RichTextEditor.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

/**
 This view can be used to view and edit rich text in SwiftUI.

 The view uses a platform-specific ``RichTextView`` together
 with a ``RichTextContext`` and a ``RichTextCoordinator`` to
 keep the view and context in sync.

 You can use the provided context to trigger and observe any
 changes to the text editor. Note that changing the value of
 the `text` binding will not yet update the editor. Until it
 is fixed, use `setAttributedString(to:)`.

 Since the view wraps a native `UIKit` or `AppKit` text view,
 you can't apply `.toolbar` modifiers to it, like you can do
 with other SwiftUI views. This means that this doesn't work:

 ```swift
 RichTextEditor(text: $text, context: context)
     .toolbar {
         ToolbarItemGroup(placement: .keyboard) {
             ....
         }
     }
 ```

 This will not show anything. To work around this limitation,
 use a ``RichTextKeyboardToolbar`` instead.

 You can configure and style the view by applying its config
 and style view modifiers to your view hierarchy:

 ```swift
 VStack {
    RichTextEditor(...)
    ...
 }
 .richTextEditorStyle(...)
 .richTextEditorConfig(...)
 ```

 For more information, see ``RichTextKeyboardToolbarConfig``
 and ``RichTextKeyboardToolbarStyle``.
 */
public struct RichTextEditor: ViewRepresentable {

    /// Create a rich text editor with a rich text value and
    /// a certain rich text data format.
    ///
    /// - Parameters:
    ///   - text: The rich text to edit.
    ///   - context: The rich text context to use.
    ///   - format: The rich text data format, by default `.archivedData`.
    ///   - viewConfiguration: A platform-specific view configuration, if any.
    public init(
        text: Binding<NSAttributedString>,
        context: RichTextContext,
        format: RichTextDataFormat = .archivedData,
        viewConfiguration: @escaping ViewConfiguration = { _ in }
    ) {
        self.text = text
        self._context = ObservedObject(wrappedValue: context)
        self.format = format
        self.viewConfiguration = viewConfiguration
    }

    public typealias ViewConfiguration = (RichTextViewComponent) -> Void

    @ObservedObject
    private var context: RichTextContext

    private var text: Binding<NSAttributedString>
    private var format: RichTextDataFormat
    private var viewConfiguration: ViewConfiguration

    @Environment(\.richTextEditorConfig)
    private var config

    @Environment(\.richTextEditorStyle)
    private var style

    #if iOS || os(tvOS) || os(visionOS)
    public let textView = RichTextView()
    #endif

    #if macOS
    public let scrollView = RichTextView.scrollableTextView()

    public var textView: RichTextView {
        scrollView.hasVerticalScroller = config.isScrollBarsVisible
        return scrollView.documentView as? RichTextView ?? RichTextView()
    }
    #endif

    public func makeCoordinator() -> RichTextCoordinator {
        RichTextCoordinator(
            text: text,
            textView: textView,
            richTextContext: context
        )
    }

    #if iOS || os(tvOS) || os(visionOS)
    public func makeUIView(context: Context) -> RichTextView {
        textView.setup(with: text.wrappedValue, format: format)
        textView.configuration = config
        textView.theme = style
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        viewConfiguration(textView)
        return textView
    }

    public func updateUIView(_ view: UIViewType, context: Context) {}

    #else

    public func makeNSView(context: Context) -> some NSView {
        textView.setup(with: text.wrappedValue, format: format)
        textView.configuration = config
        textView.theme = style
        viewConfiguration(textView)
        return scrollView
    }

    public func updateNSView(_ view: NSViewType, context: Context) {}

 

    @available(iOS 16.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        let dimensions = proposal.replacingUnspecifiedDimensions(
            by: .init(
                width: 0,
                height: CGFloat.greatestFiniteMagnitude
            )
        )

        return .init(
            width: dimensions.width,
            height: textView.sizeThatFits(dimensions).height
        )
    }
    #endif
}

// MARK: RichTextPresenter

public extension RichTextEditor {

    /// Get the currently selected range.
    var selectedRange: NSRange {
        textView.selectedRange
    }
}

// MARK: RichTextReader

public extension RichTextEditor {

    /// Get the string that is managed by the editor.
    var attributedString: NSAttributedString {
        text.wrappedValue
    }
}

// MARK: RichTextWriter

public extension RichTextEditor {

    /// Get the mutable string that is managed by the editor.
    var mutableAttributedString: NSMutableAttributedString? {
        textView.mutableAttributedString
    }
}
#endif
