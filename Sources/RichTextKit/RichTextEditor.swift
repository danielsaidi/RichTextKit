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
 This SwiftUI text editor can be used to edit rich text with
 an embedded ``RichTextView`` view, a ``RichTextContext`` as
 well as a ``RichTextCoordinator``.

 When you create an editor, you just have to provide it with
 a rich text context. The editor will then set up everything
 so that you only have to use the context to observe changes
 and trigger changes in the editor.
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

    public typealias ViewConfiguration = (RichTextViewRepresentable) -> Void


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
            context: richTextContext)
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
