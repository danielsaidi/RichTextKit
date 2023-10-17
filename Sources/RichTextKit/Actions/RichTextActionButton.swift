//
//  RichTextActionButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This button can be used to trigger a ``RichTextAction``.
 
 This renders a plain `Button`, which means that you can use
 and configure it as normal.
 */
public struct RichTextActionButton: View {
    
    /**
     Create a rich text action button.
     
     - Parameters:
       - action: The action to trigger.
       - context: The context to affect.
       - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
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
        Button(action: triggerAction) {
            action.icon
                .frame(maxHeight: fillVertically ? .infinity : nil)
                .contentShape(Rectangle())
        }
        .disabled(!context.canHandle(action))
        .keyboardShortcut(for: action)
        .accessibilityLabel(action.title)
    }
}

private extension RichTextActionButton {
    
    func triggerAction() {
        context.handle(action)
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
                    context: context,
                    fillVertically: true
                )
                RichTextActionButton(
                    action: .redoLatestChange,
                    context: context,
                    fillVertically: true
                )
                RichTextActionButton(
                    action: .undoLatestChange,
                    context: context,
                    fillVertically: true
                )
                RichTextActionButton(
                    action: .stepFontSize(points: 1),
                    context: context,
                    fillVertically: true
                )
                RichTextActionButton(
                    action: .stepFontSize(points: -1),
                    context: context,
                    fillVertically: true
                )
                RichTextActionButton(
                    action: .decreaseIndent,
                    context: context,
                    fillVertically: true
                )
                RichTextActionButton(
                    action: .increaseIndent,
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
