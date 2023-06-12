//
//  RichTextEditor.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

/**
 This SwiftUI editor can be used to view and edit rich text.

 The view uses a platform-specific ``RichTextView`` together
 with a ``RichTextContext`` and a ``RichTextCoordinator`` to
 make any changes to the rich text context display correctly
 everywhere.

 The rich text editor must be provided with a `text` binding,
 a rich text `context` and a data `format`. It will then set
 up the platform-specific view with the provided context and
 coordinator, after which you can use the context to trigger
 changes and observe any changes.

 Note that since the view wraps a native `UIKit` or `AppKit`
 view, you can not provide it with any toolbar actions. This
 means that this code doesn't work:

 ```swift
 RichTextEditor(text: $text, context: context)
     .toolbar {
         ToolbarItemGroup(placement: .keyboard) {
             ....
         }
     }
 ```

 The above code will simply not show anything when you start
 to edit text. To work around the limitation on iOS, you can
 use a ``RichTextKeyboardToolbar`` instead.

 You may have noticed that `updateUIView/updateNSView` don't
 contain any code. This is because having updates there will
 update this view, which in turn makes typing very slow. Use
 the rich text context to modify the text instead.
 */
public struct RichTextEditor: ViewRepresentable {

    /**
     Create a rich text editor with a certain text that uses
     a certain rich text data format.

     - Parameters:
       - text: The rich text to edit.
       - context: The rich text context to use.
       - format: The rich text data format, by default ``RichTextDataFormat/archivedData``.
     */
    public init(
        text: Binding<NSAttributedString>,
        context: RichTextContext,
        format: RichTextDataFormat = .archivedData,
        viewConfiguration: @escaping ViewConfiguration = { _ in }
    ) {
        self.text = text
        self._richTextContext = ObservedObject(wrappedValue: context)
        self.format = format
        self.viewConfiguration = viewConfiguration
    }

    public typealias ViewConfiguration = (RichTextViewComponent) -> Void


    private var format: RichTextDataFormat
    
    private var text: Binding<NSAttributedString>

    @ObservedObject
    private var richTextContext: RichTextContext

    private var viewConfiguration: ViewConfiguration


    #if os(iOS) || os(tvOS)
    public let textView = RichTextView()
    #endif

    #if os(macOS)
    public let scrollView = RichTextView.scrollableTextView()

    public var textView: RichTextView {
        scrollView.documentView as? RichTextView ?? RichTextView()
    }
    #endif


    public func makeCoordinator() -> RichTextCoordinator {
        RichTextCoordinator(
            text: text,
            textView: textView,
            richTextContext: richTextContext
        )
    }


    #if os(iOS) || os(tvOS)
    public func makeUIView(context: Context) -> some UIView {
        textView.setup(with: text.wrappedValue, format: format)
        viewConfiguration(textView)
        return textView
    }

    public func updateUIView(_ view: UIViewType, context: Context) {}
    #endif

    #if os(macOS)
    public func makeNSView(context: Context) -> some NSView {
        textView.setup(with: text.wrappedValue, format: format)
        viewConfiguration(textView)
        return scrollView
    }

    public func updateNSView(_ view: NSViewType, context: Context) {}
    #endif
}


// MARK: RichTextPresenter

public extension RichTextEditor {

    /**
     Get the currently selected range.
     */
    var selectedRange: NSRange {
        textView.selectedRange
    }
}


// MARK: RichTextReader

public extension RichTextEditor {

    /**
     Get the rich text that is managed by the editor.
     */
    var attributedString: NSAttributedString {
        text.wrappedValue
    }
}


// MARK: RichTextWriter

public extension RichTextEditor {

    /**
     Get the mutable rich text that is managed by the editor.
     */
    var mutableAttributedString: NSMutableAttributedString? {
        textView.mutableAttributedString
    }
}

#endif
