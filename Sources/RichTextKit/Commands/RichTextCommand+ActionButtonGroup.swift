//
//  RichTextCommand+ActionButtonGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextCommand {

    /**
     This view can add list of ``RichTextAction`` buttons to
     the main menu.

     This view requires that a ``RichTextContext`` is set as
     a focused value, otherwise it will be disabled.
     */
    struct ActionButtonGroup: View {

        /**
         Create a custom action button group.

         - Parameters:
           - actions: The actions to trigger.
         */
        public init(
            actions: [RichTextAction]
        ) {
            self.actions = actions
        }

        private let actions: [RichTextAction]

        private let step = 1

        public var body: some View {
            ForEach(actions) {
                ActionButton(action: $0)
            }
        }
    }
}

public extension RichTextCommand.ActionButtonGroup {

    /// Create a button group with alignments.
    init(
        alignments: [RichTextAlignment],
        additionalActions: [RichTextAction] = []
    ) {
        self.actions = RichTextAlignment.allCases.map {
            .setAlignment($0)
        } + additionalActions
    }

    /// Create a button group with font size steppers.
    init(
        fontSize: Bool,
        additionalActions: [RichTextAction] = []
    ) {
        self.actions = [
            .stepFontSize(points: 1),
            .stepFontSize(points: -1)
        ] + additionalActions
    }

    /// Create a button group with indent steppers.
    init(
        indent: Bool,
        additionalActions: [RichTextAction] = []
    ) {
        self.actions = [
            .stepIndent(points: 30),
            .stepIndent(points: -30)
        ] + additionalActions
    }

    /// Create a button group with line spacing steppers.
    init(
        lineSpacing: Bool,
        additionalActions: [RichTextAction] = []
    ) {
        self.actions = [
            .stepLineSpacing(points: 1),
            .stepLineSpacing(points: -1)
        ] + additionalActions
    }

    /// Create a button group with style toggles.
    init(
        styles: [RichTextStyle],
        additionalActions: [RichTextAction] = []
    ) {
        self.actions = styles.map {
            .toggleStyle($0)
        } + additionalActions
    }

    /// Create a button group with superscript steppers.
    init(
        superscript: Bool,
        additionalActions: [RichTextAction] = []
    ) {
        self.actions = [
            .stepSuperscript(steps: -1),
            .stepSuperscript(steps: 1)
        ] + additionalActions
    }
}
