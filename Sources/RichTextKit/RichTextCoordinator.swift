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
       - textView: The rich text view to keep in sync.
       - richTextContext: The context to keep in sync.
     */
    public init(
        text: Binding<NSAttributedString>,
        textView: RichTextView,
        richTextContext: RichTextContext) {
        textView.attributedString = text.wrappedValue
        self.text = text
        self.textView = textView
        self.richTextContext = richTextContext
        super.init()
        self.textView.delegate = self
        subscribeToContextChanges()
    }


    // MARK: - Properties

    /**
     The rich text context for which the coordinator is used.
     */
    public let richTextContext: RichTextContext

    /**
     The rich text to edit.
     */
    public var text: Binding<NSAttributedString>

    /**
     The text view for which the coordinator is used.
     */
    public private(set) var textView: RichTextView

    /**
     This set is used to store context observations.
     */
    public var cancellables = Set<AnyCancellable>()

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
        richTextContext.isEditingText = true
    }

    open func textViewDidChange(_ textView: UITextView) {
        syncWithTextView()
    }

    open func textViewDidChangeSelection(_ textView: UITextView) {
        syncWithTextView()
    }

    open func textViewDidEndEditing(_ textView: UITextView) {
        richTextContext.isEditingText = false
    }
    #endif


    #if canImport(AppKit)

    // MARK: - NSTextViewDelegate

    open func textDidBeginEditing(_ notification: Notification) {
        richTextContext.isEditingText = true
    }

    open func textDidChange(_ notification: Notification) {
        syncWithTextView()
    }

    open func textViewDidChangeSelection(_ notification: Notification) {
        syncWithTextView()
    }

    open func textDidEndEditing(_ notification: Notification) {
        richTextContext.isEditingText = false
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


// MARK: - Public Extensions

public extension RichTextCoordinator {

    /**
     Reset the apperance for the currently highlighted range,
     if any.
     */
    func resetHighlightedRangeAppearance() {
        guard
            let range = richTextContext.highlightedRange,
            let background = highlightedRangeOriginalBackgroundColor,
            let foreground = highlightedRangeOriginalForegroundColor
        else { return }
        textView.setBackgroundColor(to: background, at: range)
        textView.setForegroundColor(to: foreground, at: range)
    }
}


// MARK: - Internal Extensions

extension RichTextCoordinator {

    /**
     Sync state from the text view's current state.
     */
    func syncWithTextView() {
        syncContextWithTextView()
        syncTextWithTextView()
    }

    /**
     Sync the rich text context with the text view.
     */
    func syncContextWithTextView() {
        DispatchQueue.main.async {
            self.syncContextWithTextViewAfterDelay()
        }
    }

    /**
     Sync the rich text context with the text view after the
     dispatch queue delay above. The delay will silence some
     purple alert warnings about how state is updated.
     */
    func syncContextWithTextViewAfterDelay() {
        let styles = textView.currentRichTextStyles
        richTextContext.selectedRange = textView.selectedRange
        richTextContext.backgroundColor = textView.currentBackgroundColor
        richTextContext.canCopy = textView.hasSelectedRange
        richTextContext.canRedoLatestChange = textView.undoManager?.canRedo ?? false
        richTextContext.canUndoLatestChange = textView.undoManager?.canUndo ?? false
        richTextContext.fontName = textView.currentFontName ?? ""
        richTextContext.fontSize = textView.currentFontSize ?? .standardRichTextFontSize
        richTextContext.foregroundColor = textView.currentForegroundColor
        richTextContext.isBold = styles.hasStyle(.bold)
        richTextContext.isItalic = styles.hasStyle(.italic)
        richTextContext.isUnderlined = styles.hasStyle(.underlined)
        richTextContext.isEditingText = textView.isFirstResponder
        richTextContext.textAlignment = textView.currentRichTextAlignment ?? .left
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
