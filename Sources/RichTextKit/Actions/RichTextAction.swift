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
        case .copy: return .richTextActionCopy
        case .dismissKeyboard: return .richTextActionDismissKeyboard
        case .print: return .richTextActionExport
        case .redoLatestChange: return .richTextActionRedo
        case .setAlignment(let alignment): return alignment.icon
        case .stepFontSize(let points):
            return points < 0 ? .richTextFontSizeDecrease : .richTextFontSizeIncrease
        case .stepIndent(let points):
            return points < 0 ? .richTextIndentDecrease : .richTextIndentIncrease
        case .stepSuperscript(let steps):
            return steps < 0 ? .richTextSuperscriptDecrease : .richTextSuperscriptIncrease
        case .toggleStyle(let style): return style.icon
        case .undoLatestChange: return .richTextActionUndo
        }
    }
    
    /// The localized title to use in the main menu.
    var menuTitle: String {
        switch self {
        case .stepIndent(let points):
            return (points < 0 ? RTKL10n.menuIndentDecrease : .menuIndentIncrease).text
        default: return title
        }
    }
    
    /// The localized title.
    var title: String {
        switch self {
        case .copy: return RTKL10n.actionCopy.text
        case .dismissKeyboard: return RTKL10n.actionDismissKeyboard.text
        case .print: return RTKL10n.menuPrint.text
        case .redoLatestChange: return RTKL10n.actionRedoLatestChange.text
        case .setAlignment(let alignment): return alignment.title
        case .stepFontSize(let points):
            return (points < 0 ? RTKL10n.actionFontSizeDecrease : .actionFontSizeIncrease).text
        case .stepIndent(let points):
            return (points < 0 ? RTKL10n.actionIndentDecrease : .actionIndentIncrease).text
        case .stepSuperscript(let steps):
            return (steps < 0 ? RTKL10n.actionIndentDecrease : .actionIndentIncrease).text
        case .toggleStyle(let style): return style.title
        case .undoLatestChange: return RTKL10n.actionUndoLatestChange.text
        }
    }
}


// MARK: - Aliases

public extension RichTextAction {
    
    /// A name alias for `.stepFontSize`.
    static var increaseFontSize: RichTextAction {
        increaseFontSize()
    }
    
    /// A name alias for `.stepFontSize`.
    static func increaseFontSize(
        points: UInt = 1
    ) -> RichTextAction {
        stepFontSize(points: Int(points))
    }
    
    /// A name alias for `.stepFontSize`.
    static var decreaseFontSize: RichTextAction {
        decreaseFontSize()
    }
    
    /// A name alias for `.stepFontSize(points: -1)`.
    static func decreaseFontSize(
        points: UInt = 1
    ) -> RichTextAction {
        stepFontSize(points: -Int(points))
    }
    
    
    /// A name alias for `.stepIndent`.
    static var increaseIndent: RichTextAction {
        increaseIndent()
    }
    
    /// A name alias for `.stepIndent`.
    static func increaseIndent(
        points: UInt = .defaultRichTextIntentStepSize
    ) -> RichTextAction {
        stepIndent(points: CGFloat(points))
    }
    
    /// A name alias for `.stepIndent`.
    static var decreaseIndent: RichTextAction {
        decreaseIndent()
    }
    
    /// A name alias for `.stepIndent(points: -1)`.
    static func decreaseIndent(
        points: UInt = .defaultRichTextIntentStepSize
    ) -> RichTextAction {
        stepIndent(points: -CGFloat(points))
    }
    
    
    /// A name alias for `.stepFontSize`.
    static var increaseSuperscript: RichTextAction {
        increaseFontSize()
    }
    
    /// A name alias for `.stepSuperscript`.
    static func increaseSuperscript(
        steps: UInt = 1
    ) -> RichTextAction {
        stepSuperscript(steps: Int(steps))
    }
    
    /// A name alias for `.stepSuperscript`.
    static var decreaseSuperscript: RichTextAction {
        decreaseSuperscript()
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
