//
//  RichTextAction.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum defines rich text actions that can be executed on
 a rich text editor.
 */
public enum RichTextAction: String, CaseIterable, Identifiable {

    /// Copy the currently selected text, if any.
    case copy

    /// Increment the current font size.
    case incrementFontSize

    /// Decrement the current font size.
    case decrementFontSize

    /// Redo the latest undone change.
    case redoLatestChange

    /// Undo the latest change.
    case undoLatestChange
}

public extension RichTextAction {

    /// All available rich text actions.
    static var all: [Self] { allCases }

    /// A name alias for `.redoLatestChange`.
    static var redo: RichTextAction { .redoLatestChange }

    /// A name alias for `.undoLatestChange`.
    static var undo: RichTextAction { .undoLatestChange }
}

public extension Collection where Element == RichTextAction {

    /// All available rich text actions.
    static var all: [RichTextAction] { RichTextAction.allCases }
}

public extension RichTextAction {

    /// The action's unique identifier.
    var id: String { rawValue }

    /// The standard icon to use for the action.
    var icon: Image {
        switch self {
        case .copy: return .richTextActionCopy
        case .incrementFontSize: return .richTextFontSizeIncrement
        case .decrementFontSize: return .richTextFontSizeDecrement
        case .redoLatestChange: return .richTextActionRedo
        case .undoLatestChange: return .richTextActionUndo
        }
    }
}
