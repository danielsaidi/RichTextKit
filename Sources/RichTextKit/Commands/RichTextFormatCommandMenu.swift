//
//  RichTextFormatCommandMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This command menu can be used to add rich text menu options
 for text formatting to an app's menu bar.

 The commands will be disabled if there's no focus value for
 a ``RichTextContext``. Make sure to add it to the editor to
 make these commands work:

 ```swift
 RichTextEditor(...)
    .focusedValue(\.richTextContext, richTextContext)
 ```
 */
public struct RichTextFormatCommandMenu: Commands {

    /// Create a rich text format command menu.
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
                Menu(RTKL10n.menuIndent.text) {
                    RichTextCommandsIndentOptionsGroup()
                }
            }.disabled(context == nil)
        }
    }
}
#endif
