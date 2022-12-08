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

    /// Redo the latest undone change.
    case redoLatestChange

    /// Undo the latest change.
    case undoLatestChange
}

public extension RichTextAction {

    /// All available rich text actions.
    static var all: [Self] { allCases }
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
        case .copy: return Image.richTextActionCopy
        case .redoLatestChange: return Image.richTextActionRedo
        case .undoLatestChange: return Image.richTextActionUndo
        }
    }
}
