//
//  RichTextActionButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This button can be used to trigger a predefined action.

 This renders a plain `Button`, which means that you can use
 and configure it as normal.
 */
public struct RichTextActionButton: View {

    /**
     Create a rich text action button.

     - Parameters:
       - action: The action to trigger.
       - context: The context to affect.
     */
    public init(
        action: RichTextAction,
        context: RichTextContext
    ) {
        self.action = action
        self._context = ObservedObject(wrappedValue: context)
    }

    private let action: RichTextAction

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        Button(action: triggerAction) {
            action.icon
                .contentShape(Rectangle())
        }
        .disabled(!canTriggerAction)
        .keyboardShortcut(for: action)
    }
}

private extension RichTextActionButton {

    var canTriggerAction: Bool {
        context.canTriggerRichTextAction(action)
    }

    func triggerAction() {
        guard canTriggerAction else { return }
        context.triggerRichTextAction(action)
    }
}

struct RichTextActionButton_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            HStack {
                RichTextActionButton(
                    action: .copy,
                    context: context)
                RichTextActionButton(
                    action: .redoLatestChange,
                    context: context)
                RichTextActionButton(
                    action: .undoLatestChange,
                    context: context)
            }.padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
