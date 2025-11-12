#if iOS || macOS || os(tvOS) || os(visionOS)
import Combine
import SwiftUI

/// This is used to sync ``RichTextView`` in with a ``RichTextContext``.
///
/// This is used by ``RichTextEditor`` to coordinate changes in its context
/// and the underlying text view. It sets itself as the text view delegate and updates
/// the context when things change in the text view, and vice versa.
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
        super.init()
        subscribeToUserActions()
    }

    // MARK: - Properties

    /// This set is used to store context observations.
    public var cancellables = Set<AnyCancellable>()

    /// This flag is used to avoid delaying context sync.
    var shouldDelaySyncContextWithTextView = true

    // MARK: - Internal Properties

    /// The background color used before any current highlighted range was set.
    var highlightedRangeOriginalBackgroundColor: ColorRepresentable?


    /// The foreground color used before any current highlighted range was set.
     var highlightedRangeOriginalForegroundColor: ColorRepresentable?
}

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
        sync(&context.paragraphStyle, with: textView.richTextParagraphStyle ?? .defaultMutable)

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

    /// On macOS, we have to update the font and colors when we move a text
    /// input cursor with no selected text.
    ///
    /// The code may look strange, but setting the values resets the text view in
    /// a way that is otherwise not correct.
    ///
    /// To try out the incorrect behavior, disable this code, then change font size,
    /// colors etc. for a part of the text, then move the input cursor. When you do,
    /// the information will show correctly, but as you type, the last selected font,
    /// colors etc. will be used.
    func updateTextViewAttributesIfNeeded() {
        #if macOS
        if textView.hasSelectedRange { return }
        let attributes = textView.richTextAttributes
        textView.setRichTextAttributes(attributes)
        #endif
    }

    /// On macOS, we have to update the typingAttributes when we move a text
    /// input cursor and there's no selected text.
    ///
    /// So that the current attributes will set again for updated location.
    func replaceCurrentAttributesIfNeeded() {
        #if macOS
        if textView.hasSelectedRange { return }
        let attributes = textView.richTextAttributes
        textView.setNewRichTextAttributes(attributes)
        #endif
    }
}
#endif
