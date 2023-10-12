//
//  RichTextActionButtonStack.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-06-01.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view can list ``RichTextAction`` buttons in a stack.

 Since this view controls multiple values, it binds directly
 to a ``RichTextContext`` instead of to individual values.
 */
public struct RichTextActionButtonStack: View {

    /**
     Create a rich text action button stack.

     - Parameters:
       - context: The context to affect.
       - actions: The actions to list, by default all non-size actions.
       - spacing: The spacing to apply to stack items, by default `5`.
     */
    public init(
        context: RichTextContext,
        actions: [RichTextAction],
        spacing: Double = 5
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.actions = actions
        self.spacing = spacing
    }

    private let actions: [RichTextAction]
    private let spacing: Double

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(actions) {
                RichTextActionButton(
                    action: $0,
                    context: context,
                    fillVertically: true
                ).frame(maxHeight: .infinity)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct RichTextActionButtonStack_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextActionButtonStack(
                context: context,
                actions: [.undoLatestChange, .redoLatestChange, .copy]
            )
            .buttonStyle(.bordered)
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
