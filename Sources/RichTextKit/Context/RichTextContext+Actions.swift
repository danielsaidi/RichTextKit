//
//  RichTextContext+Actions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {

    /**
     Whether or not the context can trigger a certain action.

     - Parameters:
       - action: The action to trigger.
     */
    func canTriggerRichTextAction(_ action: RichTextAction) -> Bool {
        switch action {
        case .copy: return canCopy
        case .dismissKeyboard: return true
        case .print: return false
        case .redoLatestChange: return canRedoLatestChange
        case .stepFontSize: return true
        case .stepIndent(let points):
            return points < 0 ? canDecreaseIndent : canIncreaseIndent
        case .stepSuperscript: return false
        case .undoLatestChange: return canUndoLatestChange
        }
    }

    /**
     Trigger a certain rich text action.

     - Parameters:
       - action: The action to trigger.
     */
    func triggerRichTextAction(_ action: RichTextAction) {
        switch action {
        case .copy: copyCurrentSelection()
        case .dismissKeyboard: stopEditingText()
        case .print: return
        case .redoLatestChange: redoLatestChange()
        case .stepFontSize(let points): stepFontSize(points: points)
        case .stepIndent(let points): stepIndent(points: points)
        case .stepSuperscript(let steps): return
        case .undoLatestChange: undoLatestChange()
        }
    }
}
