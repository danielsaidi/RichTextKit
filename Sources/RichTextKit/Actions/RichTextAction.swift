//
//  RichTextAction.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum defines rich text actions that can be executed on
 a rich text editor.
 
 This type also serves as a type namespace for other related
 types and views, like ``RichTextAction/Button``.
 */
public enum RichTextAction: Identifiable, Equatable {

    /// Copy the currently selected text, if any.
    case copy

    /// Dismiss any presented software keyboard.
    case dismissKeyboard

    /// A print command.
    case print

    /// Redo the latest undone change.
    case redoLatestChange

    /// Set the text alignment.
    case setAlignment(_ alignment: RichTextAlignment)

    /// Step the font size.
    case stepFontSize(points: Int)

    /// Step the indent level.
    case stepIndent(points: CGFloat)

    /// Step the superscript level.
    case stepSuperscript(steps: Int)

    /// Toggle a certain style.
    case toggleStyle(_ style: RichTextStyle)

    /// Undo the latest change.
    case undoLatestChange
}

public extension RichTextAction {

    /// The action's unique identifier.
    var id: String { title }

    /// The action's standard icon.
    var icon: Image {
        switch self {
        case .copy: .richTextActionCopy
        case .dismissKeyboard: .richTextActionDismissKeyboard
        case .print: .richTextActionExport
        case .redoLatestChange: .richTextActionRedo
        case .setAlignment(let val): val.icon
        case .stepFontSize(let val): .richTextStepFontSize(val)
        case .stepIndent(let val): .richTextStepIndent(val)
        case .stepSuperscript(let val): .richTextStepSuperscript(val)
        case .toggleStyle(let val): val.icon
        case .undoLatestChange: .richTextActionUndo
        }
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
        case .print: .actionPrint
        case .redoLatestChange: .actionRedoLatestChange
        case .setAlignment(let alignment): alignment.titleKey
        case .stepFontSize(let points): .actionStepFontSize(points)
        case .stepIndent(let points): .actionStepIndent(points)
        case .stepSuperscript(let steps): .actionStepSuperscript(steps)
        case .toggleStyle(let style): style.titleKey
        case .undoLatestChange: .actionUndoLatestChange
        }
    }
}


// MARK: - Aliases

public extension RichTextAction {

    /// A name alias for `.stepFontSize`.
    static func increaseFontSize(
        points: UInt = 1
    ) -> RichTextAction {
        stepFontSize(points: Int(points))
    }

    /// A name alias for `.stepFontSize(points: -1)`.
    static func decreaseFontSize(
        points: UInt = 1
    ) -> RichTextAction {
        stepFontSize(points: -Int(points))
    }

    /// A name alias for `.stepIndent`.
    static func increaseIndent(
        points: UInt = .defaultRichTextIntentStepSize
    ) -> RichTextAction {
        stepIndent(points: CGFloat(points))
    }

    /// A name alias for `.stepIndent(points: -1)`.
    static func decreaseIndent(
        points: UInt = .defaultRichTextIntentStepSize
    ) -> RichTextAction {
        stepIndent(points: -CGFloat(points))
    }

    /// A name alias for `.stepSuperscript`.
    static func increaseSuperscript(
        steps: UInt = 1
    ) -> RichTextAction {
        stepSuperscript(steps: Int(steps))
    }

    /// A name alias for `.stepSuperscript(steps: -1)`.
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
