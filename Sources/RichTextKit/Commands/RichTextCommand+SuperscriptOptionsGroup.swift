//
//  RichTextCommand+SuperscriptOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-14.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextCommand {

    /**
     This group can add a list of superscript options to the
     main menu, using an ``RichTextCommand/ActionButtonGroup``.
     
     This view requires that a ``RichTextContext`` is set as
     a focused value, otherwise it will be disabled.
     */
    struct SuperscriptOptionsGroup: View {

        public var body: some View {
            ActionButtonGroup(
                actions: [
                    .increaseSuperscript(),
                    .decreaseSuperscript()
                ]
            )
        }
    }
}
