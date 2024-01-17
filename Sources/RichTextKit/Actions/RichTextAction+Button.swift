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
                action.icon
                    .frame(maxHeight: fillVertically ? .infinity : nil)
                    .contentShape(Rectangle())
            }
            .keyboardShortcut(for: action)
            .accessibilityLabel(action.title)
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

        var body: some View {
            HStack {
                RichTextAction.Button(
                    action: .copy,
                    context: context,
                    fillVertically: true
                )
                RichTextAction.Button(
                    action: .redoLatestChange,
                    context: context,
                    fillVertically: true
                )
                RichTextAction.Button(
                    action: .undoLatestChange,
                    context: context,
                    fillVertically: true
                )
                RichTextAction.Button(
                    action: .stepFontSize(points: 1),
                    context: context,
                    fillVertically: true
                )
                RichTextAction.Button(
                    action: .stepFontSize(points: -1),
                    context: context,
                    fillVertically: true
                )
                RichTextAction.Button(
                    action: .decreaseIndent(),
                    context: context,
                    fillVertically: true
                )
                RichTextAction.Button(
                    action: .increaseIndent(),
                    context: context,
                    fillVertically: true
                )
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .buttonStyle(.bordered)
        }
    }

    static var previews: some View {
        Preview()
    }
}
