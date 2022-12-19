//
//  RichTextCommandsAlignmentOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view can be added to a `Commands`, to expose rich text
 alignment menu options to an app main menu or key commands.
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
