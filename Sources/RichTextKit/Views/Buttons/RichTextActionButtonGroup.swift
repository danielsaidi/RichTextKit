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
       - bordered: Whether or not the buttons are bordered, by default `true`.
       - actions: The actions to list, by default ``RichTextAction/all``.
     */
    public init(
        context: RichTextContext,
        bordered: Bool = true,
        actions: [RichTextAction] = .all
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.bordered = bordered
        self.actions = actions
    }

    private let actions: [RichTextAction]

    private let bordered: Bool

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(actions) {
                RichTextActionButton(
                    action: $0,
                    context: context
                ).frame(maxHeight: .infinity)
            }
        }
        .bordered(if: bordered)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private extension View {

    @ViewBuilder
    func bordered(if condition: Bool) -> some View {
        if condition, #available(iOS 15.0, macOS 12.0, *) {
            self.buttonStyle(.bordered)
        } else {
            self
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
