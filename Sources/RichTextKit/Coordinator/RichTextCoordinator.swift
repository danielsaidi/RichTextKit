//
//  RichTextCoordinator.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import Combine
import SwiftUI

/**
 This coordinator is used to keep a ``RichTextView`` in sync
 with a ``RichTextContext``.

 This is used by ``RichTextEditor`` to coordinate changes in
 its context and the underlying text view.

 The coordinator sets itself as the text view's delegate. It
 updates the context when things change in the text view and
 syncs to context changes to the text view.
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
        richTextContext: RichTextContext
    ) {
        textView.attributedString = text.wrappedValue
        self.text = text
        self.textView = textView
        self.context = richTextContext
        super.init()
        self.textView.delegate = self
        subscribeToUserActions()
    }

    // MARK: - Properties

    /// The rich text context to coordinate with.
    public let context: RichTextContext

    /// The rich text to edit.
    public var text: Binding<NSAttributedString>

    /// The text view for which the coordinator is used.
    public private(set) var textView: RichTextView

    /// This set is used to store context observations.
    public var cancellables = Set<AnyCancellable>()

    /// This flag is used to avoid delaying context sync.
    var shouldDelaySyncContextWithTextView = true

    // MARK: - Internal Properties

    /**
     The background color that was used before the currently
     highlighted range was set.
     */
    var highlightedRangeOriginalBackgroundColor: ColorRepresentable?

    /**
     The foreground color that was used before the currently
     highlighted range was set.
     */
     var highlightedRangeOriginalForegroundColor: ColorRepresentable?

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
        syncWithTextView()
        context.isEditingText = false
    }
    #endif

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)

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

#if iOS || os(tvOS) || os(visionOS)
import UIKit

extension RichTextCoordinator: UITextViewDelegate {}

#elseif macOS
import AppKit

extension RichTextCoordinator: NSTextViewDelegate {}
#endif

// MARK: - Public Extensions

public extension RichTextCoordinator {

    /// Reset appearance for the currently highlighted range.
    func resetHighlightedRangeAppearance() {
        guard
            let range = context.highlightedRange,
            let background = highlightedRangeOriginalBackgroundColor,
            let foreground = highlightedRangeOriginalForegroundColor
        else { return }
        textView.setRichTextColor(.background, to: background, at: range)
        textView.setRichTextColor(.foreground, to: foreground, at: range)
    }
}

// MARK: - Internal Extensions

extension RichTextCoordinator {

    /// Sync state from the text view's current state.
    func syncWithTextView() {
        syncContextWithTextView()
        syncTextWithTextView()
    }

    /// Sync the rich text context with the text view.
    func syncContextWithTextView() {
        if shouldDelaySyncContextWithTextView {
            DispatchQueue.main.async {
                self.syncContextWithTextViewAfterDelay()
            }
        } else {
            syncContextWithTextViewAfterDelay()
        }
    }

    /// Sync the rich text context with the text view.
    func syncContextWithTextViewAfterDelay() {
        let styles = textView.richTextStyles

        let string = textView.attributedString
        if context.attributedString != string {
            context.attributedString = string
        }

        let range = textView.selectedRange
        if context.selectedRange != range {
            context.selectedRange = range
        }

        RichTextColor.allCases.forEach {
            if let color = textView.richTextColor($0) {
                context.setColor($0, to: color)
            }
        }

        let hasRange = textView.hasSelectedRange
        if context.canCopy != hasRange {
            context.canCopy = hasRange
        }

        let canRedo = textView.undoManager?.canRedo ?? false
        if context.canRedoLatestChange != canRedo {
            context.canRedoLatestChange = canRedo
        }

        let canUndo = textView.undoManager?.canUndo ?? false
        if context.canUndoLatestChange != canUndo {
            context.canUndoLatestChange = canUndo
        }

        if let fontName = textView.richTextFont?.fontName,
            !fontName.isEmpty,
            context.fontName != fontName {
            context.fontName = fontName
        }

        let fontSize = textView.richTextFont?.pointSize ?? .standardRichTextFontSize
        if context.fontSize != fontSize {
            context.fontSize = fontSize
        }

        RichTextStyle.all.forEach {
            let style = styles.hasStyle($0)
            context.setStyleInternal($0, to: style)
        }

        let isEditingText = textView.isFirstResponder
        if context.isEditingText != isEditingText {
            context.isEditingText = isEditingText
        }

        let lineSpacing = textView.richTextLineSpacing ?? 10.0
        if context.lineSpacing != lineSpacing {
            context.lineSpacing = lineSpacing
        }

        if let textAlignment = textView.richTextAlignment,
            context.textAlignment != textAlignment {
            context.textAlignment = textAlignment
        }

        updateTextViewAttributesIfNeeded()
    }

    /// Sync the text binding with the text view.
    func syncTextWithTextView() {
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
        #if macOS
        if textView.hasSelectedRange { return }
        let attributes = textView.richTextAttributes
        textView.setRichTextAttributes(attributes)
        #endif
    }
}
#endif
