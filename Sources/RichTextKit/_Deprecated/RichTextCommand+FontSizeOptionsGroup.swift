//
//  RichTextCommand+FontSizeOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextCommand {

    @available(*, deprecated, message: "Use RichTextCommand.ActionButtonGroup fontSize initializer instead.")
    struct FontSizeOptionsGroup: View {

        public init() {}

        public var body: some View {
            ActionButtonGroup(
                actions: [
                    .increaseFontSize(),
                    .decreaseFontSize()
                ]
            )
        }
    }
}
