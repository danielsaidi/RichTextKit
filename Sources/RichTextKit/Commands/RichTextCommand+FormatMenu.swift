//
//  RichTextCommand+FormatMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextCommand {

    /**
     This menu adds standard rich text format options to the
     main menu, using `CommandGroup`.
     
     You can apply this to a `WindowGroup` or `DocumentGroup`
     to make it appear in the app's main menu.
     
     This menu requires that a ``RichTextContext`` is set as
     a focused value, otherwise it will be disabled.
     */
    struct FormatMenu: Commands {

        /// Create a rich text format command menu.
        public init() {}

        @FocusedValue(\.richTextContext)
        private var context: RichTextContext?

        public var body: some Commands {
            CommandMenu(RTKL10n.menuFormat.text) {
                Group {
                    Menu(RTKL10n.menuFont.text) {
                        ActionButtonGroup(styles: .all)
                        Divider()
                        ActionButtonGroup(fontSize: true)
                    }
                    Menu(RTKL10n.menuText.text) {
                        ActionButtonGroup(alignments: .all)
                    }
                    Menu(RTKL10n.menuIndent.text) {
                        ActionButtonGroup(indent: true)
                    }
                    Menu(RTKL10n.menuSuperscript.text) {
                        ActionButtonGroup(superscript: true)
                    }
                }
                .disabled(context == nil)
            }
        }
    }
}
#endif
