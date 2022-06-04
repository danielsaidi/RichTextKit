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

    /**
     This flag is used to handle font size stepping.
     */
    internal var isSteppingFontSize = false


    // MARK: - Internal Properties

    /**
     The background color that was used before the currently
     highlighted range was set.
     */
    internal var highlightedRangeOriginalBackgroundColor: ColorRepresentable?

    /**
     The foreground color that was used before the currently
     highlighted range was set.
     */
    internal var highlightedRangeOriginalForegroundColor: ColorRepresentable?


    #if canImport(UIKit)

    // MARK: - UITextViewDelegate

    open func textViewDidBeginEditing(_ textView: UITextView) {
        context.isEditingText = true
    }

    open func textViewDidChange(_ textView: UITextView) {
        syncWithTextView()
    }

    open func textViewDidChangeSelection(_ textView: UITextView) {
        syncWithTextView()
    }

    open func textViewDidEndEditing(_ textView: UITextView) {
        context.isEditingText = false
    }
    #endif


    #if canImport(AppKit)

    // MARK: - NSTextViewDelegate

    open func textDidBeginEditing(_ notification: Notification) {
        context.isEditingText = true
    }

    open func textDidChange(_ notification: Notification) {
        syncWithTextView()
    }

    open func textViewDidChangeSelection(_ notification: Notification) {
        syncWithTextView()
    }

    open func textDidEndEditing(_ notification: Notification) {
        context.isEditingText = false
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


extension RichTextCoordinator {

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
        let styles = textView.currentRichTextStyles
        context.alignment = textView.currentRichTextAlignment ?? .left
        context.backgroundColor = textView.currentBackgroundColor
        context.canCopy = textView.hasSelectedRange
        context.canRedoLatestChange = textView.undoManager?.canRedo ?? false
        context.canUndoLatestChange = textView.undoManager?.canUndo ?? false
        context.fontName = textView.currentFontName ?? ""
        context.fontSize = textView.currentFontSize ?? .standardRichTextFontSize
        context.foregroundColor = textView.currentForegroundColor
        context.isBold = styles.hasStyle(.bold)
        context.isItalic = styles.hasStyle(.italic)
        context.isUnderlined = styles.hasStyle(.underlined)
        context.isEditingText = textView.isFirstResponder
        context.selectedRange = textView.selectedRange
        updateTextViewAttributesIfNeeded()
    }

    /**
     Sync the text binding with the text view.
     */
    func syncTextWithTextView() {
        if text.wrappedValue == textView.attributedString { return }
        DispatchQueue.main.async {
            self.text.wrappedValue = self.textView.attributedString
        }
    }

    /**
     On macOS, we have to update the font and colors when we
     move the text input cursor and there's no selected text.

     The code looks very strange, but setting current values
     to the current values will reset the text view in a way
     that is otherwise not done correctly.

     To try out the incorrect behavior, comment out the code
     below, then change font size, colors etc. for a part of
     the text then move the input cursor around. When you do,
     the presented information will be correct, but when you
     type, the last selected font, colors etc. will be used.
     */
    func updateTextViewAttributesIfNeeded() {
        #if os(macOS)
        if textView.hasSelectedRange { return }
        let attributes = textView.currentRichTextAttributes
        textView.setCurrentRichTextAttributes(attributes)
        #endif
    }
}
#endif
