//
//  RichTextAction.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum defines rich text actions that can be executed on
 a rich text editor.
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
    
    /// Step the font size.
    case stepFontSize(points: Int)
    
    /// Step the indent level.
    case stepIndent(points: CGFloat)
    
    /// Step the superscript level.
    case stepSuperscript(steps: Int)
    
    /// Undo the latest change.
    case undoLatestChange
}

public extension RichTextAction {
    
    /// A name alias for `.stepFontSize(points: 1)`.
    static var increaseFontSize: RichTextAction { stepFontSize(points: 1) }

    /// A name alias for `.stepFontSize(points: -1)`.
    static var decreaseFontSize: RichTextAction { stepFontSize(points: -1) }
    
    /// A name alias for `.stepIndent(points: 1)`.
    static var increaseIndent: RichTextAction { stepIndent(points: 1) }

    /// A name alias for `.stepIndent(points: -1)`.
    static var decreaseIndent: RichTextAction { stepIndent(points: -1) }
    
    /// A name alias for `.stepSuperscript(steps: 1)`.
    static var increaseSuperscript: RichTextAction { stepSuperscript(steps: 1) }

    /// A name alias for `.stepSuperscript(steps: -1)`.
    static var decreaseSuperscript: RichTextAction { stepSuperscript(steps: -1) }

    /// A name alias for `.redoLatestChange`.
    static var redo: RichTextAction { .redoLatestChange }

    /// A name alias for `.undoLatestChange`.
    static var undo: RichTextAction { .undoLatestChange }
    
    /// The action's unique identifier.
    var id: String { localizedName }

    /// The actions's localized name.
    var localizedName: String {
        switch self {
        case .copy: return RTKL10n.actionCopy.text
        case .dismissKeyboard: return RTKL10n.actionDismissKeyboard.text
        case .print: return RTKL10n.menuPrint.text
        case .redoLatestChange: return RTKL10n.actionRedoLatestChange.text
        case .stepFontSize(let points):
            return (points < 0 ? RTKL10n.actionDecreaseFontSize : .actionIncreaseFontSize).text
        case .stepIndent(let points):
            return (points < 0 ? RTKL10n.actionDecreaseIndent : .actionIncreaseIndent).text
        case .stepSuperscript(let steps):
            return (steps < 0 ? RTKL10n.actionDecreaseIndent : .actionIncreaseIndent).text
        case .undoLatestChange: return RTKL10n.actionUndoLatestChange.text
        }
    }

    /// The action's standard icon.
    var icon: Image {
        switch self {
        case .copy: return .richTextActionCopy
        case .dismissKeyboard: return .richTextActionDismissKeyboard
        case .print: return .richTextActionExport
        case .redoLatestChange: return .richTextActionRedo
        case .stepFontSize(let points):
            return points < 0 ? .richTextFontSizeDecrease : .richTextFontSizeIncrease
        case .stepIndent(let points):
            return points < 0 ? .richTextIndentDecrease : .richTextIndentIncrease
        case .stepSuperscript(let steps):
            return steps < 0 ? .richTextSuperscriptDecrease : .richTextSuperscriptIncrease
        case .undoLatestChange: return .richTextActionUndo
        }
    }
}
