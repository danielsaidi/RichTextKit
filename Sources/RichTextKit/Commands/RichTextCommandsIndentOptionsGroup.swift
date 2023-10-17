//
//  RichTextCommandsIndentOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view defines `Commands` content for indent options.
 */
public struct RichTextCommandsIndentOptionsGroup: View {

    @FocusedValue(\.richTextContext)
    private var context: RichTextContext?
    
    public var body: some View {
        RichTextCommandButtonGroup(
            actions: [
                .increaseIndent,
                .decreaseIndent
            ]
        )
    }
}
