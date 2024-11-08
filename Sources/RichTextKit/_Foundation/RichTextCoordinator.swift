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

/// This class is used to keep ``RichTextView`` in sync with
/// a ``RichTextContext``.
///
/// This is used by ``RichTextEditor`` to coordinate changes
/// in its context and the underlying text view. It will set
/// itself as the text view delegate, and update the context
/// when things change in the text view, and vice versa.
@preconcurrency @MainActor
open class RichTextCoordinator: NSObject {

    // MARK: - Initialization

    /// Create a rich text coordinator.
    ///
    /// - Parameters:
    ///   - text: The rich text to edit.
    ///   - textView: The rich text view to keep in sync.
    ///   - richTextContext: The context to keep in sync.
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

    /// The background color that was set before any current
    /// highlighted range was set.
    var highlightedRangeOriginalBackgroundColor: ColorRepresentable?


    /// The foreground color that was set before any current
    /// highlighted range was set.
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

    func sync<T: Equatable>(_ prop: inout T, with value: T) {
        if prop == value { return }
        prop = value
    }

    /// Sync the rich text context with the text view.
    func syncContextWithTextViewAfterDelay() {
        let font = textView.richTextFont ?? .standardRichTextFont
        sync(&context.attributedString, with: textView.attributedString)
        sync(&context.selectedRange, with: textView.selectedRange)
        sync(&context.canCopy, with: textView.hasSelectedRange)
        sync(&context.canRedoLatestChange, with: textView.undoManager?.canRedo ?? false)
        sync(&context.canUndoLatestChange, with: textView.undoManager?.canUndo ?? false)
        sync(&context.fontName, with: font.fontName)
        sync(&context.fontSize, with: font.pointSize)
        sync(&context.isEditingText, with: textView.isFirstResponder)
        sync(&context.headerLevel, with: textView.richTextHeaderLevel ?? .paragraph)
        // sync(&context.lineSpacing, with: textView.richTextLineSpacing ?? 10.0)   TODO: Not done yet
        sync(&context.paragraphStyle, with: textView.richTextParagraphStyle ?? .default)
        sync(&context.textAlignment, with: textView.richTextAlignment ?? .left)

        RichTextColor.allCases.forEach {
            if let color = textView.richTextColor($0) {
                context.setColor($0, to: color)
            }
        }

        let styles = textView.richTextStyles
        RichTextStyle.all.forEach {
            let style = styles.hasStyle($0)
            context.setStyleInternal($0, to: style)
        }

        updateTextViewAttributesIfNeeded()
    }

    /// Sync the text binding with the text view.
    func syncTextWithTextView() {
        DispatchQueue.main.async {
            self.text.wrappedValue = self.textView.attributedString
        }
    }

    /// On macOS, we have to update the font and colors when
    /// we move the text input cursor with no selected text.
    ///
    /// The code may look strange, but setting values resets
    /// the text view in a way that is otherwise not correct.
    ///
    /// To try out the incorrect behavior, disable this code,
    /// then change font size, colors etc. for a part of the
    /// text, then move the input cursor around. When you do,
    /// the information will show correctly, but as you type,
    /// the last selected font, colors etc. will be used.
    func updateTextViewAttributesIfNeeded() {
        #if macOS
        if textView.hasSelectedRange { return }
        let attributes = textView.richTextAttributes
        textView.setRichTextAttributes(attributes)
        #endif
    }
}
#endif
