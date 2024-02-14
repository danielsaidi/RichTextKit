//
//  RichTextContext.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI
import Combine

/**
 This observable context can be used to affect and observe a
 ``RichTextEditor`` and its content.

 Use ``handle(_:)`` to trigger a change, e.g. to change font,
 text style, alignment, select a range, etc. You can observe
 the various published properties to keep your UI updated as
 the context changes.

 The SwiftUI ``RichTextEditor`` uses this context as well as
 a ``RichTextCoordinator`` to keep itself updated.
 */
public class RichTextContext: ObservableObject {

    /// Create a new rich text context instance.
    public init() {}

    // MARK: - Not yet observable properties

    /**
     The currently attributed string, if any.

     Note that the property is read-only and not `@Published`
     to avoid redrawing the editor when it changes, which is
     done as the user types. We should find a way to observe
     it without this happening. The best way to observe this
     property is to use the raw `text` binding that you pass
     into the text editor. The editor will not redraw if you
     change this value from the outside.

     Until then, use `setAttributedString(to:)` to change it.
     */
    public internal(set) var attributedString = NSAttributedString()

    /// The currently selected range, if any.
    public internal(set) var selectedRange = NSRange()

    // MARK: - Public properies

    /// Whether or not the text is currently being edited.
    @Published
    public var isEditingText = false

    /// The current text alignment, if any.
    @Published
    public var textAlignment: RichTextAlignment = .left

    /// The current font name.
    @Published
    public var fontName = ""

    /// The current font size.
    @Published
    public var fontSize = CGFloat.standardRichTextFontSize

    /// The currently highlighted range, if any.
    public var highlightedRange: NSRange?

    /// Use this Publisher to emit any attribute changes to textView.
    public let userActionPublisher: PassthroughSubject<RichTextAction, Never> = .init()

    // MARK: - Internal properties

    /// The current background color, if any.
    @Published
    public internal(set) var backgroundColor: ColorRepresentable?

    /// Whether or not the current rich text can be copied.
    @Published
    public internal(set) var canCopy = false

    /// Whether or not the latest undone change can be redone.
    @Published
    public internal(set) var canRedoLatestChange = false

    /// Whether or not the latest change can be undone.
    @Published
    public internal(set) var canUndoLatestChange = false

    /// Whether or not the indent level can be decreased.
    @Published
    public internal(set) var canDecreaseIndent = true

    /// Whether or not the indent level can be increased.
    @Published
    public internal(set) var canIncreaseIndent = true

    /// The current foreground color, if any.
    @Published
    public internal(set) var foregroundColor: ColorRepresentable?

    /// The style to apply when highlighting a range.
    @Published
    public internal(set) var highlightingStyle = RichTextHighlightingStyle.standard

    /// Whether or not the current text is bold.
    @Published
    public internal(set) var isBold = false

    /// Whether or not the current text is italic.
    @Published
    public internal(set) var isItalic = false

    /// Whether or not the current text is striked through.
    @Published
    public internal(set) var isStrikethrough = false

    /// Whether or not the current text is underlined.
    @Published
    public internal(set) var isUnderlined = false

    /// The current strikethrough color, if any.
    @Published
    public internal(set) var strikethroughColor: ColorRepresentable?

    /// The current stroke color, if any.
    @Published
    public internal(set) var strokeColor: ColorRepresentable?

    /// The current underline color, if any.
    @Published
    public internal(set) var underlineColor: ColorRepresentable?
}

public extension RichTextContext {

    /// Whether or not the context has a selected range.
    var hasHighlightedRange: Bool {
        highlightedRange != nil
    }

    /// Whether or not the context has a selected range.
    var hasSelectedRange: Bool {
        selectedRange.length > 0
    }
}

public extension RichTextContext {

    /// Set ``highlightedRange`` to a new, optional range.
    func highlightRange(_ range: NSRange?) {
        userActionPublisher.send(.setHighlightedRange(range))
        highlightedRange = range
    }

    /// Reset the attributed string.
    func resetAttributedString() {
        setAttributedString(to: "")
    }

    /// Reset the ``highlightedRange``.
    func resetHighlightedRange() {
        guard hasHighlightedRange else { return }
        highlightedRange = nil
    }

    /// Reset the ``selectedRange``.
    func resetSelectedRange() {
        selectedRange = NSRange(location: 0, length: 0)
    }

    /// Set a new range and start editing.
    func selectRange(_ range: NSRange) {
        isEditingText = true
        userActionPublisher.send(.selectRange(range))
    }

    /// Set the attributed string to a new plain text.
    func setAttributedString(to text: String) {
        setAttributedString(to: NSAttributedString(string: text))
    }

    /// Set the attributed string to a new rich text.
    func setAttributedString(to string: NSAttributedString) {
        let mutable = NSMutableAttributedString(attributedString: string)
        mutable.setRichTextFontSize(fontSize, at: mutable.richTextRange)
        userActionPublisher.send(.setAttributedString(mutable))
    }

    /// Set ``isEditingText`` to `false`.
    func stopEditingText() {
        isEditingText = false
    }

    /// Toggle whether or not the text is being edited.
    func toggleIsEditing() {
        isEditingText.toggle()
    }
}
