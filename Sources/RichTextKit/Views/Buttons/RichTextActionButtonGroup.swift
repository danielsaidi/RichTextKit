//
//  RichTextActionButtonGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-08.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view can be used to list ``RichTextActionButton``s for
 a ``RichTextAction`` collection.
 */
public struct RichTextActionButtonGroup: View {

    /**
     Create a rich text style toggle button group.

     - Parameters:
       - context: The context to affect.
       - actions: The actions to list, by default ``RichTextAction/all``.
     */
    public init(
        context: RichTextContext,
        actions: [RichTextAction] = .all
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.actions = actions
    }

    private let actions: [RichTextAction]

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(actions) {
                RichTextActionButton(
                    action: $0,
                    context: context
                )
            }
        }
    }
}

struct RichTextActionButtonGroup_Previews: PreviewProvider {

    struct Preview: View {

        @StateObject
        private var context = RichTextContext()

        var body: some View {
            RichTextActionButtonGroup(context: context)
                .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
