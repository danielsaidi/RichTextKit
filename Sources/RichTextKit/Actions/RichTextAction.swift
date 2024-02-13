//
//  RichTextAction.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI
import Combine

/**
 This enum defines rich text actions that can be executed on
 a rich text editor.

 This type also serves as a type namespace for other related
 types and views, like ``RichTextAction/Button``.
 */
public enum RichTextAction: Identifiable, Equatable, RichTextLabelValue {

    /// Copy the currently selected text, if any.
    case copy

    /// Dismiss any presented software keyboard.
    case dismissKeyboard

    /// Paste a single image.
    case pasteImage(RichTextInsertion<ImageRepresentable>)

    /// Paste multiple images.
    case pasteImages(RichTextInsertion<[ImageRepresentable]>)

    /// Paste plain text.
    case pasteText(RichTextInsertion<String>)

    /// A print command.
    case print

    /// Redo the latest undone change.
    case redoLatestChange

    /// Select a range.
    case selectRange(NSRange)

    /// Set the text alignment.
    case setAlignment(_ alignment: RichTextAlignment)

    /// Set the entire attributed string.
    case setAttributedString(NSAttributedString)

    // Change background color
    case setColor(RichTextColor, ColorRepresentable)

    // Highlighted renge
    case setHighlightedRange(NSRange?)

    // Change highlighting style
    case setHighlightingStyle(RichTextHighlightingStyle)

    /// Set a certain ``RichTextStyle``.
    case setStyle(RichTextStyle, Bool)

    /// Step the font size.
    case stepFontSize(points: Int)

    /// Step the indent level.
    case stepIndent(points: CGFloat)

    /// Step the line spacing.
    case stepLineSpacing(points: CGFloat)

    /// Step the superscript level.
    case stepSuperscript(steps: Int)

    /// Toggle a certain style.
    case toggleStyle(_ style: RichTextStyle)

    /// Undo the latest change.
    case undoLatestChange

    case link(url: URL?)
}

public extension RichTextAction {

    typealias Publisher = PassthroughSubject<Self, Never>

    /// The action's unique identifier.
    var id: String { title }

    /// The action's standard icon.
    var icon: Image {
        switch self {
        case .copy: .richTextActionCopy
        case .dismissKeyboard: .richTextActionDismissKeyboard
        case .pasteImage: .richTextDocuments
        case .pasteImages: .richTextDocuments
        case .pasteText: .richTextDocuments
        case .print: .richTextActionExport
        case .redoLatestChange: .richTextActionRedo
        case .selectRange: .richTextSelection
        case .setAlignment(let val): val.icon
        case .setAttributedString: .richTextDocument
        case .setColor(let color, _): color.icon
        case .setHighlightedRange: .richTextAlignmentCenter
        case .setHighlightingStyle: .richTextAlignmentCenter
        case .setStyle(let style, _): style.icon
        case .stepFontSize(let val): .richTextStepFontSize(val)
        case .stepIndent(let val): .richTextStepIndent(val)
        case .stepLineSpacing: .richTextLineSpacing
        case .stepSuperscript(let val): .richTextStepSuperscript(val)
        case .toggleStyle(let val): val.icon
        case .undoLatestChange: .richTextActionUndo
        case .link: .richTextKindLink
        }
    }

    /// The localized label to use for the action.
    var label: some View {
        icon.label(title)
    }

    /// The localized title to use in the main menu.
    var menuTitle: String {
        menuTitleKey.text
    }

    /// The localized title key to use in the main menu.
    var menuTitleKey: RTKL10n {
        switch self {
        case .stepIndent(let points): .menuIndent(points)
        default: titleKey
        }
    }

    /// The localized action title.
    var title: String {
        titleKey.text
    }

    /// The localized action title key.
    var titleKey: RTKL10n {
        switch self {
        case .copy: .actionCopy
        case .dismissKeyboard: .actionDismissKeyboard
        case .pasteImage: .pasteImage
        case .pasteImages: .pasteImages
        case .pasteText: .pasteText
        case .print: .actionPrint
        case .redoLatestChange: .actionRedoLatestChange
        case .selectRange: .selectRange
        case .setAlignment(let alignment): alignment.titleKey
        case .setAttributedString: .setAttributedString
        case .setColor(let color, _): color.titleKey
        case .setHighlightedRange: .highlightedRange
        case .setHighlightingStyle: .highlightingStyle
        case .setStyle(let style, _): style.titleKey
        case .stepFontSize(let points): .actionStepFontSize(points)
        case .stepIndent(let points): .actionStepIndent(points)
        case .stepLineSpacing(let points): .actionStepLineSpacing(points)
        case .stepSuperscript(let steps): .actionStepSuperscript(steps)
        case .toggleStyle(let style): style.titleKey
        case .undoLatestChange: .actionUndoLatestChange
        case .link: .actionCopy // TODO: Link
        }
    }
}

// MARK: - Aliases

public extension RichTextAction {

    @available(*, deprecated, message: "Use stepFontSize directly")
    static func increaseFontSize(
        points: UInt = 1
    ) -> RichTextAction {
        stepFontSize(points: Int(points))
    }

    @available(*, deprecated, message: "Use stepFontSize directly")
    static func decreaseFontSize(
        points: UInt = 1
    ) -> RichTextAction {
        stepFontSize(points: -Int(points))
    }

    @available(*, deprecated, message: "Use stepIndent directly")
    static func increaseIndent(
        points: UInt = .defaultRichTextIntentStepSize
    ) -> RichTextAction {
        stepIndent(points: CGFloat(points))
    }

    @available(*, deprecated, message: "Use stepIndent directly")
    static func decreaseIndent(
        points: UInt = .defaultRichTextIntentStepSize
    ) -> RichTextAction {
        stepIndent(points: -CGFloat(points))
    }

    @available(*, deprecated, message: "Use stepSuperscript directly")
    static func increaseSuperscript(
        steps: UInt = 1
    ) -> RichTextAction {
        stepSuperscript(steps: Int(steps))
    }

    @available(*, deprecated, message: "Use stepSuperscript directly")
    static func decreaseSuperscript(
        steps: UInt = 1
    ) -> RichTextAction {
        stepSuperscript(steps: -Int(steps))
    }

    /// A name alias for `.redoLatestChange`.
    static var redo: RichTextAction { .redoLatestChange }

    /// A name alias for `.undoLatestChange`.
    static var undo: RichTextAction { .undoLatestChange }
}

public extension CGFloat {

    /// The default rich text indent step size.
    static var defaultRichTextIntentStepSize: CGFloat = 30.0
}

public extension UInt {

    /// The default rich text indent step size.
    static var defaultRichTextIntentStepSize: UInt = 30
}
