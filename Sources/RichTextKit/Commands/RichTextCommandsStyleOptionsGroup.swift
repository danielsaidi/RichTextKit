//
//  RichTextCommandsStyleOptionsGroup.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view can be added to a `Commands`, to expose rich text
 style menu options to an app main menu or key commands.
 */
public struct RichTextCommandsStyleOptionsGroup: View {

    public init() {}

    @FocusedValue(\.richTextContext)
    private var context: RichTextContext?

    public var body: some View {
        Button(RTKL10n.styleBold.text) {
            context?.isBold.toggle()
        }.keyboardShortcut(for: .bold)

        Button(RTKL10n.styleItalic.text) {
            context?.isItalic.toggle()
        }.keyboardShortcut(for: .italic)

        Button(RTKL10n.styleUnderlined.text) {
            context?.isUnderlined.toggle()
        }.keyboardShortcut(for: .underlined)

        Button(RTKL10n.styleStrikethrough.text) {
            context?.isStrikethrough.toggle()
        }.keyboardShortcut(for: .strikethrough)
    }
}
