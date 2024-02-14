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
     This view renders superscript command options.
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
