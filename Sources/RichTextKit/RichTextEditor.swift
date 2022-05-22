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
 well as a ``RichTextEditorCoordinator``.

 When you create an editor, you just have to provide it with
 a rich text context. The editor will then set up everything
 so that you only have to use the context to observe changes
 and trigger changes in the editor.
 */
public struct RichTextEditor: ViewRepresentable {

    /**
     Create a rich text editor.

     - Parameters:
       - text: The rich text to edit.
     */
    public init(text: Binding<NSAttributedString>) {
        self._attributedString = text
    }


    @Binding
    public var attributedString: NSAttributedString


    #if os(iOS) || os(tvOS)
    public let textView = RichTextView()
    #endif

    #if os(macOS)
    public let scrollView = RichTextView.scrollableTextView()

    public var textView: RichTextView {
        scrollView.documentView as? RichTextView ?? RichTextView()
    }
    #endif


    #if os(iOS) || os(tvOS)
    public func makeUIView(context: Context) -> some UIView {
        textView.attributedText = attributedString
        return textView
    }

    public func updateUIView(_ view: UIViewType, context: Context) {}
    #endif

    #if os(macOS)
    public func makeNSView(context: Context) -> some NSView {
        textView.attributedText = attributedString
        return scrollView
    }

    public func updateNSView(_ view: NSViewType, context: Context) {}
    #endif
}
#endif
