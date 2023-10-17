//
//  RichTextCommandButton.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This button can be used to trigger a ``RichTextAction``.
 
 This button gets the ``RichTextContext`` as a focused value.
 
 The button renders a plain `Button` with a title and action,
 that is meant to be used in a `Commands` group and rendered
 in the main menu.
 */
public struct RichTextCommandButton: View {
    
    /**
     Create a rich text command button.
     
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
        Button(action.menuTitle) {
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

public struct RichTextCommandButtonGroup: View {
    
    /**
     Create a rich text command button group.
     
     - Parameters:
       - actions: The actions to trigger.
     */
    public init(
        actions: [RichTextAction]
    ) {
        self.actions = actions
    }
    
    private let actions: [RichTextAction]
    
    public var body: some View {
        ForEach(actions) {
            RichTextCommandButton(action: $0)
        }
    }
}
