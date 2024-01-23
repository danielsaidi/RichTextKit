//
//  RichTextCommand+ActionButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextCommand {

    /**
     This button can be used to trigger any ``RichTextAction``
     from a main menu command item.

     This button gets ``RichTextContext`` as a focused value.
     It will be nil if no view has focus, which will disable
     the button altogether.
     */
    struct ActionButton: View {

        /**
         Create a command button.

         - Parameters:
         - action: The action to trigger.
         */
        public init(
            action: RichTextAction
        ) {
            self.action = action
        }

        private let action: RichTextAction

        @FocusedValue(\.richTextContext)
        private var context: RichTextContext?

        public var body: some View {
            SwiftUI.Button(action.menuTitle) {
                context?.handle(action)
            }
            .disabled(!canHandle)
            .keyboardShortcut(for: action)
            .accessibilityLabel(action.title)
        }

        private var canHandle: Bool {
            context?.canHandle(action) ?? false
        }
    }
}
