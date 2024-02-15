//
//  RichTextCommand+SuperscriptOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-02-14.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextCommand {

    @available(*, deprecated, message: "Use RichTextCommand.ActionButtonGroup superscript initializer instead.")
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
