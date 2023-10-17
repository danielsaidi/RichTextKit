//
//  RichTextContext+Actions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {
    
    /// Handle a certain rich text action.
    func handle(_ action: RichTextAction) {
        switch action {
        case .setAlignment(let align): textAlignment = align
        case .stepFontSize(let points): fontSize += CGFloat(points)
        case .toggleStyle(let style): toggle(style)
        default: triggerAction = action
        }
    }

    /// Check if the context can handle a certain action.
    func canHandle(_ action: RichTextAction) -> Bool {
        switch action {
        case .copy: return canCopy
        case .dismissKeyboard: return true
        case .print: return false
        case .redoLatestChange: return canRedoLatestChange
        case .setAlignment: return true
        case .stepFontSize: return true
        case .stepIndent(let points):
            return points < 0 ? canDecreaseIndent : canIncreaseIndent
        case .stepSuperscript: return false
        case .toggleStyle: return true
        case .undoLatestChange: return canUndoLatestChange
        }
    }
}
