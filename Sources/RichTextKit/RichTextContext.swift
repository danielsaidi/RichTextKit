//
//  RichTextContext.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This context can be used to observe state for any rich text
 view, as well as other editor-specific properties.

 SwiftUI can observe the published properties to keep the UI
 of an app in sync, while a coordinator can subscribe to any
 property to keep a wrapped text view in sync.
 */
public class RichTextContext: ObservableObject {

    /**
     Create a new rich text context.

     - Parameters:
       - standardFontSize: The font size to use by default.
     */
    public init(
        standardFontSize: CGFloat = .standardRichTextFontSize
    ) {
        self.fontSize = standardFontSize
    }


    // MARK: - Properties

    /**
     A custom binding that can be used to set the background
     color with e.g. a SwitUI `ColorPicker`.
     */
    public var backgroundColorBinding: Binding<Color> {
        Binding(
            get: { Color(self.backgroundColor ?? .clear) },
            set: { self.backgroundColor = ColorRepresentable($0)}
        )
    }

    /**
     The standard highlighting style to apply when setting a
     highlighted range.
     */
    public var standardHighlightingStyle = RichTextHighlightingStyle.standard


    // MARK: - Published Properties

    /**
     The current text alignment, if any.
     */
    @Published
    public var alignment: RichTextAlignment = .left

    /**
     The current background color, if any.
     */
    @Published
    public var backgroundColor: ColorRepresentable? = nil

    /**
     Whether or not the current rich text can be copied.
     */
    @Published
    public var canCopy = false

    /**
     Whether or not the latest undone change can be redone.
     */
    @Published
    public var canRedoLatestChange = false

    /**
     Whether or not the latest change can be undone.
     */
    @Published
    public var canUndoLatestChange = false

    /**
     The current font name.
     */
    @Published
    public var fontName = ""

    /**
     The current font size.
     */
    @Published
    public var fontSize: CGFloat

    /**
     The current foreground color, if any.
     */
    @Published
    public var foregroundColor: ColorRepresentable? = nil

    /**
     A custom binding that can be used to set the foreground
     color with e.g. a SwitUI `ColorPicker`.
     */
    public var foregroundColorBinding: Binding<Color> {
        Binding(
            get: { Color(self.foregroundColor ?? .clear) },
            set: { self.foregroundColor = ColorRepresentable($0)}
        )
    }

    /**
     The currently highlighted range, if any.
     */
    @Published
    public var highlightedRange: NSRange?

    /**
     Whether or not the current text is bold.
     */
    @Published
    public var isBold = false

    /**
     Whether or not the rich text is currently being edited.
     */
    @Published
    public var isEditingText = false

    /**
     Whether or not the current text is italic.
     */
    @Published
    public var isItalic = false

    /**
     Whether or not the current text is underlined.
     */
    @Published
    public var isUnderlined = false

    /**
     The currently selected range, if any.
     */
    @Published
    public var selectedRange = NSRange()

    /**
     Whether or not to undo the latest change.
     */
    @Published
    public var shouldUndoLatestChange = false

    /**
     Whether or not to redo the latest undone change.
     */
    @Published
    public var shouldRedoLatestChange = false
}

public extension RichTextContext {

    /**
     Whether or not the context has a selected range.
     */
    var hasSelectedRange: Bool {
        selectedRange.length > 0
    }
}

public extension RichTextContext {

    /**
     Decrement the current font size.

     - Parameters:
       - points: The number of points to decrement the font size, by default `1`.
     */
    func decrementFontSize(points: UInt = 1) {
        stepFontSize(points: -Int(points))
    }

    /**
     Whether or not a certain style is enabled.
     */
    func hasStyle(_ style: RichTextStyle) -> Bool {
        switch style {
        case .bold: return isBold
        case .italic: return isItalic
        case .underlined: return isUnderlined
        }
    }

    /**
     Set ``highlightedRange`` to a new, optional range.
     */
    func highlightRange(_ range: NSRange?) {
        highlightedRange = range
    }

    /**
     Increment the current font size.

     - Parameters:
       - points: The number of points to increment the font size, by default `1`.
     */
    func incrementFontSize(points: UInt = 1) {
        stepFontSize(points: Int(points))
    }

    /**
     Redo the latest undone change.
     */
    func redoLatestChange() {
        shouldRedoLatestChange = true
    }

    /**
     Reset the ``highlightedRange``.
     */
    func resetHighlightedRange() {
        highlightedRange = nil
    }

    /**
     Reset the ``selectedRange``.
     */
    func resetSelectedRange() {
        selectedRange = NSRange(location: 0, length: 0)
    }

    /**
     Set ``selectedRange`` to a new, optional range.
     */
    func selectRange(_ range: NSRange) {
        isEditingText = true
        selectedRange = range
    }

    /**
     Step the current font size a certain number of points.

     - Parameters:
       - points: The number of points to increase or decrease the font size.
     */
    func stepFontSize(points: Int) {
        fontSize += CGFloat(points)
    }

    /**
     Set ``isEditingText`` to `false`.
     */
    func stopEditingText() {
        isEditingText = false
    }

    /**
     Toggle a certain rich text style.
     */
    func toggle(_ style: RichTextStyle) {
        switch style {
        case .bold: isBold.toggle()
        case .italic: isItalic.toggle()
        case .underlined: isUnderlined.toggle()
        }
    }

    /**
     Toggle whether or not the text is being edited.
     */
    func toggleIsEditing() {
        isEditingText.toggle()
    }

    /**
     Undo the latest change.
     */
    func undoLatestChange() {
        shouldUndoLatestChange = true
    }
}
