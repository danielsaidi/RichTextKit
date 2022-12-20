//
//  RichTextFormatCommandMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This command menu can be used to add rich text menu options
 to an app, to control rich text formatting.

 The commands will be disabled if there's no focus value for
 a ``RichTextContext`` available. Make sure to add it to the
 editor to make these commands work:

 ```swift
 RichTextEditor(...)
    .focusedValue(\.richTextContext, richTextContext)
 ```
 */
public struct RichTextFormatCommandMenu: Commands {

    /**
     Create a rich text format command menu.
     */
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
