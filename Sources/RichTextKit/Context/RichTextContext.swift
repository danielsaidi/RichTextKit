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

 Use ``handle(_:)`` to trigger actions, e.g. to change fonts,
 text styles, text alignments, select a text range, etc.

 You can observe the various published properties to keep an
 app up to date with the current state. The ``RichTextEditor``
 uses this with a ``RichTextCoordinator`` to keep it updated.
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

    // MARK: - Bindable Properies

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

    /// The current line spacing.
    @Published
    public var lineSpacing: CGFloat = 10.0

    // MARK: - Properties

    /// This publisher can emit actions to the coordinator.
    public let actionPublisher = RichTextAction.Publisher()

    /// The currently highlighted range, if any.
    public var highlightedRange: NSRange?

    // MARK: - Deprecated Colors

    @available(*, deprecated, renamed: "colors")
    public var backgroundColor: ColorRepresentable? {
        colors[.background]
    }

    @available(*, deprecated, renamed: "colors")
    public var foregroundColor: ColorRepresentable? {
        colors[.foreground]
    }

    @available(*, deprecated, renamed: "colors")
    public var strikethroughColor: ColorRepresentable? {
        colors[.strikethrough]
    }

    @available(*, deprecated, renamed: "colors")
    public var strokeColor: ColorRepresentable? {
        colors[.stroke]
    }

    @available(*, deprecated, renamed: "colors")
    public var underlineColor: ColorRepresentable? {
        colors[.underline]
    }

    // MARK: - Deprecated Styles

    @available(*, deprecated, renamed: "styles")
    public var isBold: Bool { hasStyle(.bold) }

    @available(*, deprecated, renamed: "styles")
    public var isItalic: Bool { hasStyle(.italic) }

    @available(*, deprecated, renamed: "styles")
    public var isStrikethrough: Bool { hasStyle(.strikethrough) }

    @available(*, deprecated, renamed: "styles")
    public var isUnderlined: Bool { hasStyle(.underlined) }

    // MARK: - Observable Properties

    /// Whether or not the current rich text can be copied.
    @Published
    public internal(set) var canCopy = false

    /// Whether or not the latest undo can be redone.
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

    @Published
    public internal(set) var colors = [RichTextColor: ColorRepresentable]()

    /// The style to apply when highlighting a range.
    @Published
    public internal(set) var highlightingStyle = RichTextHighlightingStyle.standard

    @Published
    public internal(set) var styles = [RichTextStyle: Bool]()
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
        actionPublisher.send(.setHighlightedRange(range))
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
        actionPublisher.send(.selectRange(range))
    }

    /// Set the attributed string to a new plain text.
    func setAttributedString(to text: String) {
        setAttributedString(to: NSAttributedString(string: text))
    }

    /// Set the attributed string to a new rich text.
    func setAttributedString(to string: NSAttributedString) {
        let mutable = NSMutableAttributedString(attributedString: string)
        actionPublisher.send(.setAttributedString(mutable))
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
