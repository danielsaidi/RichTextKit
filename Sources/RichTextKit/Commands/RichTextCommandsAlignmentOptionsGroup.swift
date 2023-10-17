//
//  RichTextCommandsAlignmentOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view defines `Commands` content for alignment options.
 */
public struct RichTextCommandsAlignmentOptionsGroup: View {

    public init() {}

    @FocusedValue(\.richTextContext)
    private var context: RichTextContext?

    public var body: some View {
        Button(RTKL10n.textAlignmentLeft.text) {
            context?.textAlignment = .left
        }
        Button(RTKL10n.textAlignmentCentered.text) {
            context?.textAlignment = .center
        }
        Button(RTKL10n.textAlignmentRight.text) {
            context?.textAlignment = .right
        }
        Button(RTKL10n.textAlignmentJustified.text) {
            context?.textAlignment = .justified
        }
    }
}
