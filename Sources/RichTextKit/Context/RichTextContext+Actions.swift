//
//  RichTextContext+Actions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {

    /// Handle a certain rich text action.
    func handle(_ action: RichTextAction) {
        switch action {
        default: actionPublisher.send(action)
        }
    }

    /// Check if the context can handle a certain action.
    func canHandle(_ action: RichTextAction) -> Bool {
        switch action {
        case .copy: canCopy
        case .dismissKeyboard: true
        case .pasteImage: true
        case .pasteImages: true
        case .pasteText: true
        case .print: false
        case .redoLatestChange: canRedoLatestChange
        case .selectRange: true
        case .setAlignment: true
        case .setAttributedString: true
        case .setColor: true
        case .setHighlightedRange: true
        case .setHighlightingStyle: true
        case .setStyle: true
        case .stepFontSize: true
        case .stepIndent(let points):
            points < 0 ? canDecreaseIndent : canIncreaseIndent
        case .stepLineSpacing: true
        case .stepSuperscript: true
        case .toggleStyle: true
        case .undoLatestChange: canUndoLatestChange
        }
    }
    
    /// Trigger a certain rich text action.
    func trigger(_ action: RichTextAction) {
        handle(action)
    }
}
