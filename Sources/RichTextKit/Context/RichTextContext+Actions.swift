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
        case .copy: canCopy
        case .dismissKeyboard: true
        case .print: false
        case .redoLatestChange: canRedoLatestChange
        case .setAlignment: true
        case .stepFontSize: true
        case .stepIndent(let points): points < 0 ? canDecreaseIndent : canIncreaseIndent
        case .stepSuperscript: false
        case .toggleStyle: true
        case .undoLatestChange: canUndoLatestChange
        }
    }
}
