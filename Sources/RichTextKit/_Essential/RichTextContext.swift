//
//  RichTextContext.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI
import Combine

/// This class can be used to observe a ``RichTextEditor`` and its text view.
///
/// Use ``handle(_:)`` to trigger actions, e.g. to change fonts, text styles, text
/// alignments, select a text range, etc.
///
/// You can use ``RichTextContext/FocusedValueKey`` to handle focus
/// for a context in a multi-windowed app.
public class RichTextContext: ObservableObject {

    /// Create a new rich text context instance.
    public init() {}

    // MARK: - Not yet observable properties

    /// The currently attributed string, if any.
    ///
    /// Note that the property is read-only and not `@Published` to avoid any
    /// redrawing of the editor when it changes, which is done as the user types.
    /// We should find a way to observe it without this happening. The best way
    /// to observe this property is to use the raw `text` binding that you pass
    /// into the text editor. The editor will not redraw if you change this value from
    /// the outside.
    ///
    /// Until this is fixed, use `setAttributedString(to:)` to change it.
    public internal(set) var attributedString = NSAttributedString()

    /// The currently selected range, if any.
    public internal(set) var selectedRange = NSRange()

    // MARK: - Bindable & Settable Properies

    /// Whether or not the rich text editor is editable.
    @Published public var isEditable = true

    /// Whether or not the text is currently being edited.
    @Published public var isEditingText = false

    /// The current font name.
    @Published public var fontName = RichTextFont.PickerFont.all.first?.fontName ?? ""

    /// The current font size.
    @Published public var fontSize = CGFloat.standardRichTextFontSize


    // MARK: - Observable Properties

    /// Whether or not the current rich text can be copied.
    @Published public internal(set) var canCopy = false

    /// Whether or not the latest undo can be redone.
    @Published public internal(set) var canRedoLatestChange = false

    /// Whether or not the latest change can be undone.
    @Published public internal(set) var canUndoLatestChange = false

    /// The current color values.
    @Published public internal(set) var colors = [RichTextColor: ColorRepresentable]()

    /// The style to apply when highlighting a range.
    @Published public internal(set) var highlightingStyle = RichTextHighlightingStyle.standard

    /// The current paragraph style.
    @Published public internal(set) var paragraphStyle = NSMutableParagraphStyle.defaultMutable

    /// The current rich text styles.
    @Published public internal(set) var styles = [RichTextStyle: Bool]()


    // MARK: - Paragraph

    /// A paragraph style value for a certain value type.
    public func paragraphStyleValue<ValueType>(
        for keyPath: KeyPath<NSParagraphStyle, ValueType>
    ) -> ValueType {
        paragraphStyle[keyPath: keyPath]
    }

    /// A binding that binds to paragraph style values.
    public func paragraphStyleValueBinding<ValueType>(
        for keyPath: WritableKeyPath<NSMutableParagraphStyle, ValueType>
    ) -> Binding<ValueType> {
        .init {
            self.paragraphStyle[keyPath: keyPath]
        } set: { value in
            self.paragraphStyle[keyPath: keyPath] = value
        }
    }


    // MARK: - Properties

    /// This publisher can emit actions to the coordinator.
    public let actionPublisher = RichTextAction.Publisher()

    /// The currently highlighted range, if any.
    public var highlightedRange: NSRange?


    // MARK: - Deprecated

    @available(*, deprecated, message: "Use paragraphStyle instead.")
    @Published public var lineSpacing: CGFloat = 10.0

    @available(*, deprecated, message: "Use paragraphStyle instead.")
    public var textAlignment: RichTextAlignment {
        get { .init(paragraphStyleValue(for: \.alignment)) }
        set { paragraphStyle[keyPath: \.alignment] = newValue.nativeAlignment }
    }
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
