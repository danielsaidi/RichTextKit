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
     This view can be used to render a collection of actions
     as main menu command items.
     */
    struct ActionButtonGroup: View {

        /**
         Create a command button group.

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
                ActionButton(action: $0)
            }
        }
    }
}
