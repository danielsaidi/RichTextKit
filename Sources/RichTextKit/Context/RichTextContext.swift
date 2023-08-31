//
//  RichTextContext.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

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


    // MARK: - Observable properies
    
    /// The current background color, if any.
    @Published
    public var backgroundColor: ColorRepresentable?

    /// Whether or not the current rich text can be copied.
    @Published
    public var canCopy = false

    /// Whether or not the latest undone change can be redone.
    @Published
    public var canRedoLatestChange = false

    /// Whether or not the latest change can be undone.
    @Published
    public var canUndoLatestChange = false
    
    /// Whether or not the indent level can be decreased.
    @Published
    public var canDecreaseIndent = true
    
    /// Whether or not the indent level can be increased.
    @Published
    public var canIncreaseIndent = true

    /// The current font name.
    @Published
    public var fontName = ""

    /// The current font size.
    @Published
    public var fontSize = CGFloat.standardRichTextFontSize

    /// The current foreground color, if any.
    @Published
    public var foregroundColor: ColorRepresentable?

    /// The currently highlighted range, if any.
    @Published
    public var highlightedRange: NSRange?

    /// The style to apply when highlighting a range.
    @Published
    public var highlightingStyle = RichTextHighlightingStyle.standard

    /// Whether or not the current text is bold.
    @Published
    public var isBold = false

    /// Whether or not the text is currently being edited.
    @Published
    public var isEditingText = false

    /// Whether or not the current text is italic.
    @Published
    public var isItalic = false

    /// Whether or not the current text is striked through.
    @Published
    public var isStrikethrough = false

    /// Whether or not the current text is underlined.
    @Published
    public var isUnderlined = false
    
    /// The current text alignment, if any.
    @Published
    public var textAlignment: RichTextAlignment = .left
    
    
    // MARK: - Internal trigger properties
    
    /// Whether or not to copy the current text selection.
    @Published
    var shouldCopySelection = false

    /// Whether or not to redo the latest undone change.
    @Published
    var shouldRedoLatestChange = false

    /// Set this property to trigger a paste operation.
    @Published
    var shouldPasteImage: (image: ImageRepresentable, atIndex: Int, moveCursor: Bool)?

    /// Set this property to trigger an image paste operation.
    @Published
    var shouldPasteImages: (images: [ImageRepresentable], atIndex: Int, moveCursor: Bool)?

    /// Set this property to trigger a text paste operation.
    @Published
    var shouldPasteText: (text: String, atIndex: Int, moveCursor: Bool)?

    /// Set this property to trigger a string update.
    @Published
    var shouldSetAttributedString: NSAttributedString?
    
    /// Set this property to trigger a range change.
    @Published
    var shouldSelectRange = NSRange()

    /// Whether or not to undo the latest change.
    @Published
    var shouldUndoLatestChange = false

    /// Whether or not to decrease the current indent.
    @Published
    var shouldDecreaseIndent = false
    
    /// Whether or not to increase the current indent.
    @Published
    var shouldIncreaseIndent = false
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

    /// Copy the current selection to the pasteboard.
    func copyCurrentSelection() {
        shouldCopySelection = true
    }

    /// Decrement the current font size 1 point.
    func decrementFontSize() {
        decrementFontSize(points: 1)
    }

    /// Decrement the current font size a number of points.
    func decrementFontSize(points: UInt) {
        stepFontSize(points: -Int(points))
    }

    /// Whether or not a certain style is enabled.
    func hasStyle(_ style: RichTextStyle) -> Bool {
        switch style {
        case .bold: return isBold
        case .italic: return isItalic
        case .strikethrough: return isStrikethrough
        case .underlined: return isUnderlined
        }
    }

    /// Set ``highlightedRange`` to a new, optional range.
    func highlightRange(_ range: NSRange?) {
        highlightedRange = range
    }

    /// Increment the current font size 1 point.
    func incrementFontSize() {
        incrementFontSize(points: 1)
    }

    /// Increment  the current font size a number of points.
    func incrementFontSize(points: UInt) {
        stepFontSize(points: Int(points))
    }

    /**
     Paste an image into the text view, at a certain index.

     - Parameters:
       - image: The image to paste.
       - index: The index to paste at, by default the `selectedRange` location.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImage(
        _ image: ImageRepresentable,
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        shouldPasteImage = (image, index, moveCursorToPastedContent)
    }

    /**
     Paste images into the text view, at a certain index.

     - Parameters:
       - images: The images to paste.
       - index: The index to paste at, by default the `selectedRange` location.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteImage(
        _ images: [ImageRepresentable],
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        shouldPasteImages = (images, index, moveCursorToPastedContent)
    }

    /**
     Paste text into the text view, at a certain index.

     - Parameters:
       - text: The text to paste.
       - index: The index to paste at, by default the `selectedRange` location.
       - moveCursorToPastedContent: Whether or not to move the cursor to the end of the pasted content, by default `false`.
     */
    func pasteText(
        _ text: String,
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        shouldPasteText = (text, index, moveCursorToPastedContent)
    }

    /// Redo the latest undone change.
    func redoLatestChange() {
        shouldRedoLatestChange = true
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
        shouldSelectRange = range
    }

    /// Set the attributed string to a new plain text.
    func setAttributedString(to text: String) {
        setAttributedString(to: NSAttributedString(string: text))
    }

    /// Set the attributed string to a new rich text.
    func setAttributedString(to string: NSAttributedString) {
        let mutable = NSMutableAttributedString(attributedString: string)
        mutable.setFontSize(to: fontSize)
        shouldSetAttributedString = mutable
    }

    /// Step the current font size a number of points.
    func stepFontSize(points: Int) {
        fontSize += CGFloat(points)
    }

    /// Set ``isEditingText`` to `false`.
    func stopEditingText() {
        isEditingText = false
    }

    /// Toggle a certain rich text style.
    func toggle(_ style: RichTextStyle) {
        switch style {
        case .bold: isBold.toggle()
        case .italic: isItalic.toggle()
        case .strikethrough: isStrikethrough.toggle()
        case .underlined: isUnderlined.toggle()
        }
    }

    /// Toggle whether or not the text is being edited.
    func toggleIsEditing() {
        isEditingText.toggle()
    }

    /// Undo the latest change.
    func undoLatestChange() {
        shouldUndoLatestChange = true
    }
    
    /// Decrease current indent.
    func decreaseIndent() {
        shouldDecreaseIndent = true
    }
    
    /// Increase current indent.
    func increaseIndent() {
        shouldIncreaseIndent = true
    }
}
