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

 The SwiftUI ``RichTextEditor`` uses this context as well as
 a ``RichTextCoordinator`` to keep itself updated when state
 changes. The context also has properties and functions that
 are used to set context state via the coordinator.
 */
public class RichTextContext: ObservableObject {

    /// Create a new rich text context instance.
    public init() {}

    // MARK: - Not yet observable properties

    /**
     The currently attributed string, if any.

     Note that the property is read-only and not `@Published`
     to avoid redrawing the editor when it changes, which is
     done constantly as the user types. We should find a way
     to observe this property without this happening.

     The best way to observe this property is to use the raw
     `text` binding that you pass into your text editor. The
     editor will however not redraw if you change this value
     from the outside, since it aims to avoid costly redraws.

     Until then, use `setAttributedString(to:)` to change it.
     */
    public internal(set) var attributedString = NSAttributedString()

    /**
     The currently selected range, if any.

     Note that the property is read-only and not `@Published`
     to avoid redrawing the editor when it changes, which is
     done constantly as the user types. We should find a way
     to observe this property without this happening.

     Until then, use ``selectRange(_:)`` to change the value.
     */
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
    var backgroundColor: ColorRepresentable?

    /// Whether or not the current rich text can be copied.
    @Published
    var canCopy = false

    /// Whether or not the latest undone change can be redone.
    @Published
    var canRedoLatestChange = false

    /// Whether or not the latest change can be undone.
    @Published
    var canUndoLatestChange = false

    /// Whether or not the indent level can be decreased.
    @Published
    var canDecreaseIndent = true

    /// Whether or not the indent level can be increased.
    @Published
    var canIncreaseIndent = true
    
    /// The current foreground color, if any.
    @Published
    var foregroundColor: ColorRepresentable?

    /// The style to apply when highlighting a range.
    @Published
    var highlightingStyle = RichTextHighlightingStyle.standard

    /// Whether or not the current text is bold.
    @Published
    var isBold = false

    /// Whether or not the current text is italic.
    @Published
    var isItalic = false

    /// Whether or not the current text is striked through.
    @Published
    var isStrikethrough = false

    /// Whether or not the current text is underlined.
    @Published
    var isUnderlined = false

    /// The current strikethrough color, if any.
    @Published
    var strikethroughColor: ColorRepresentable?

    /// The current stroke color, if any.
    @Published
    var strokeColor: ColorRepresentable?

    /// The current underline color, if any.
    @Published
    var underlineColor: ColorRepresentable?
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

    /// Paste an image into the editor, at a certain index.
    func pasteImage(
        _ image: ImageRepresentable,
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        userActionPublisher.send(
            .pasteImage(
                RichTextInsertion(
                    content: image,
                    at: index,
                    moveCursor: moveCursorToPastedContent
                )
            )
        )
    }

    /// Paste images into the editor, at a certain index.
    func pasteImages(
        _ images: [ImageRepresentable],
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        userActionPublisher.send(
            .pasteImages(
                RichTextInsertion(
                    content: images,
                    at: index,
                    moveCursor: moveCursorToPastedContent
                )
            )
        )
    }

    /// Paste text into the editor, at a certain index.
    func pasteText(
        _ text: String,
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        userActionPublisher.send(
            .pasteText(
                RichTextInsertion(
                    content: text,
                    at: index,
                    moveCursor: moveCursorToPastedContent
                )
            )
        )
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
