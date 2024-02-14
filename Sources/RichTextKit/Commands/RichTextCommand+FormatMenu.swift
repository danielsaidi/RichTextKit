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
     This menu can be used to add format-specific options to
     the main menu bar.
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
                        StyleOptionsGroup()
                        Divider()
                        FontSizeOptionsGroup()
                    }
                    Menu(RTKL10n.menuText.text) {
                        AlignmentOptionsGroup()
                    }
                    Menu(RTKL10n.menuIndent.text) {
                        IndentOptionsGroup()
                    }
                    Menu(RTKL10n.menuSuperscript.text) {
                        SuperscriptOptionsGroup()
                    }
                }
                .disabled(context == nil)
            }
        }
    }
}
#endif
