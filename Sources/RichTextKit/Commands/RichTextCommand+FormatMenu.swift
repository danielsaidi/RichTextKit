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

    /// This menu adds format options to the main menu.
    ///
    /// You can add it to a `WindowGroup` or `DocumentGroup`,
    /// to make it appear in the app's main menu.
    ///
    /// This view requires that a ``RichTextContext`` is set
    /// as a focused value, otherwise it will be disabled.
    struct FormatMenu: Commands {

        /// Create a rich text format command menu.
        public init(
            submenus: [SubMenu] = SubMenu.allCases,
            additionalActions: [RichTextAction] = []
        ) {
            self.submenus = submenus
            self.additionalActions = additionalActions
        }

        private let submenus: [SubMenu]
        private let additionalActions: [RichTextAction]

        @FocusedValue(\.richTextContext)
        private var context: RichTextContext?

        public var body: some Commands {
            CommandMenu(RTKL10n.menuFormat.text) {
                Group {
                    ForEach(Array(submenus.enumerated()), id: \.offset) {
                        $0.element
                    }
                }
                .disabled(context == nil)

                if !additionalActions.isEmpty {
                    Divider()
                    ForEach(additionalActions) {
                        ActionButton(action: $0)
                    }
                }
            }
        }
    }
}

public extension RichTextCommand.FormatMenu {

    /// This enum defines various format sub-menus
    enum SubMenu: String, CaseIterable, View {
        case font, text, indent, lineSpacing, superscript

        typealias Group = RichTextCommand.ActionButtonGroup

        public var body: some View {
            switch self {
            case .font:
                Menu(RTKL10n.font.text) {
                    Group(styles: .all)
                    Divider()
                    Group(fontSize: true)
                }
            case .text:
                Menu(RTKL10n.menuText.text) {
                    Group(alignments: NSTextAlignment.defaultPickerValues)
                }
            case .indent:
                Menu(RTKL10n.indent.text) {
                    Group(indent: true)
                }
            case .lineSpacing:
                Menu(RTKL10n.lineSpacing.text) {
                    Group(lineSpacing: true)
                }
            case .superscript:
                Menu(RTKL10n.superscript.text) {
                    Group(superscript: true)
                }
            }
        }
    }
}
#endif
