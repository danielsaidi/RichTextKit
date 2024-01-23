//
//  RichTextActionButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextAction {

    /**
     This button can be used to trigger a ``RichTextAction``.

     This renders a plain `Button`, which means that you can
     use and configure it as a normal button.
     */
    struct Button: View {
        /**
         Create a rich text action button.

         - Parameters:
           - action: The action to trigger.
           - context: The context to affect.
           - fillVertically: WhetherP or not fill up vertical space, by default `false`.
         */
        public init(
            action: RichTextAction,
            context: RichTextContext,
            fillVertically: Bool = false
        ) {
            self.action = action
            self._context = ObservedObject(wrappedValue: context)
            self.fillVertically = fillVertically
        }

        private let action: RichTextAction
        private let fillVertically: Bool

        @ObservedObject
        private var context: RichTextContext

        public var body: some View {
            SwiftUI.Button(action: triggerAction) {
                action.label
                    .labelStyle(.iconOnly)
                    .frame(maxHeight: fillVertically ? .infinity : nil)
                    .contentShape(Rectangle())
            }
            .keyboardShortcut(for: action)
            .disabled(!context.canHandle(action))
        }
    }
}

private extension RichTextAction.Button {

    func triggerAction() {
        context.handle(action)
    }
}

struct RichTextAction_Button_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        func button(
            for action: RichTextAction
        ) -> some View {
            RichTextAction.Button(
                action: action,
                context: context,
                fillVertically: true
            )
        }

        var body: some View {
            VStack {
                Group {
                    HStack {
                        button(for: .copy)
                        button(for: .dismissKeyboard)
                        button(for: .print)
                        button(for: .redoLatestChange)
                        button(for: .undoLatestChange)
                    }
                    HStack {
                        ForEach(RichTextAlignment.allCases) {
                            button(for: .setAlignment($0))
                        }
                    }
                    HStack {
                        button(for: .stepFontSize(points: 1))
                        button(for: .stepFontSize(points: -1))
                        button(for: .stepIndent(points: 1))
                        button(for: .stepIndent(points: -1))
                        button(for: .stepSuperscript(steps: 1))
                        button(for: .stepSuperscript(steps: -1))
                    }
                    HStack {
                        ForEach(RichTextStyle.allCases) {
                            button(for: .toggleStyle($0))
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .buttonStyle(.bordered)
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
