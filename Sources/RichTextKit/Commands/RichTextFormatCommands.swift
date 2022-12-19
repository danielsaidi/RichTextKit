//
//  RichTextFormatCommands.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This Commands type can be used to expose a rich text format
 menu to an app's main menu or key commands.
 */
public struct RichTextFormatCommands: Commands {

    public init() {}

    @FocusedValue(\.richTextContext)
    private var context: RichTextContext?

    public var body: some Commands {
        CommandMenu(RTKL10n.menuFormat.text) {
            Group {
                Menu(RTKL10n.menuFont.text) {
                    RichTextCommandsStyleOptionsGroup()
                    Divider()
                    RichTextCommandsFontSizeOptionsGroup()
                }
                Menu(RTKL10n.menuText.text) {
                    RichTextCommandsAlignmentOptionsGroup()
                }
            }.disabled(context == nil)
        }
    }
}
