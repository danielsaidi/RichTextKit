//
//  RichTextCommand+AlignmentOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextCommand {

    /**
     This view can add list of text alignment options to the
     main menu, using an ``RichTextCommand/ActionButtonGroup``.
     
     This view requires that a ``RichTextContext`` is set as
     a focused value, otherwise it will be disabled.
     */
    struct AlignmentOptionsGroup: View {

        public init() {}

        public var body: some View {
            ActionButtonGroup(
                actions: RichTextAlignment.allCases.map {
                    .setAlignment($0)
                }
            )
        }
    }
}
