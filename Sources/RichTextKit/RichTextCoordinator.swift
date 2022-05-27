//
//  RichTextCoordinator.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import Combine
import SwiftUI

/**
 This coordinator is used to keep a ``RichTextView`` in sync
 with a ``RichTextContext``.

 The coordinator sets itself as the text view's delegate and
 updates the context when things change in the text view. It
 also subscribes to context observable changes and keeps the
 text view in sync with these changes.

 You can inherit this class to customize the coordinator for
 your own use cases.
 */
open class RichTextCoordinator: NSObject {

    // MARK: - Initialization

    /**
     Create a rich text coordinator.

     - Parameters:
       - text: The rich text to edit.
       - textView: The rich text view used to edit the text.
       - context: The rich text context to keep in sync.
     */
    public init(
        text: Binding<NSAttributedString>,
        textView: RichTextView,
        context: RichTextContext) {
        textView.attributedString = text.wrappedValue
        self.text = text
        self.textView = textView
        self.context = context
        super.init()
        self.textView.delegate = self
        subscribeToContextChanges()
    }


    // MARK: - Properties

    /**
     The rich text context for which the coordinator is used.
     */
    public let context: RichTextContext

    /**
     The rich text to edit.
     */
    public let text: Binding<NSAttributedString>

    /**
     The text view for which the coordinator is used.
     */
    public private(set) var textView: RichTextView

    /**
     This set is used to store context observations.
     */
    internal var cancellables = Set<AnyCancellable>()


    #if canImport(UIKit)

    // MARK: - UITextViewDelegate

    open func textViewDidChange(_ textView: UITextView) {
        syncWithTextView()
    }

    open func textViewDidChangeSelection(_ textView: UITextView) {
        syncWithTextView()
    }
    #endif


    #if canImport(AppKit)

    // MARK: - NSTextViewDelegate

    open func textDidChange(_ notification: Notification) {
        syncWithTextView()
    }

    open func textViewDidChangeSelection(_ notification: Notification) {
        syncWithTextView()
    }
    #endif
}


#if os(iOS) || os(tvOS)
import UIKit

extension RichTextCoordinator: UITextViewDelegate {}

#elseif os(macOS)
import AppKit

extension RichTextCoordinator: NSTextViewDelegate {}
#endif


private extension RichTextCoordinator {

    /**
     Sync state from the text view's current state.
     */
    func syncWithTextView() {
        syncContextWithTextView()
        syncTextWithTextView()
    }

    /**
     Sync the context with the text view.
     */
    func syncContextWithTextView() {
        let string = textView.attributedString
        let attributes = string.richTextAttributes(at: textView.selectedRange)
        let isUnderlined = (attributes[.underlineStyle] as? Int) == 1
        context.isUnderlined = isUnderlined
    }

    /**
     Sync the text binding with the text view.
     */
    func syncTextWithTextView() {
        if text.wrappedValue == textView.attributedString { return }
        text.wrappedValue = textView.attributedString
    }
}
#endif
