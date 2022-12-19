//
//  RichTextCommandsFontSizeOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view can be added to a `Commands`, to expose rich text
 font size menu options to an app main menu or key commands.
 */
public struct RichTextCommandsFontSizeOptionsGroup: View {

    public init() {}

    @FocusedValue(\.richTextContext)
    private var context: RichTextContext?

    public var body: some View {
        Button(RTKL10n.menuFontLarger.text) {
            context?.incrementFontSize()
        }.keyboardShortcut(for: .incrementFontSize)

        Button(RTKL10n.menuFontSmaller.text) {
            context?.decrementFontSize()
        }.keyboardShortcut(for: .decrementFontSize)
    }
}
