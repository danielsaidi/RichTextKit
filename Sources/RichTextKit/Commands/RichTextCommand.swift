//
//  RichTextCommand.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2023-10-12.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum defines rich text commands for command groups and
 main app menus.
 */
public enum RichTextCommand: String, CaseIterable, Identifiable {
    
    /// A print command.
    case print
}

public extension RichTextCommand {

    /// All available rich text commands.
    static var all: [Self] { allCases }

    /// The command's unique identifier.
    var id: String { rawValue }
    
    /// The commands's localized name.
    var localizedName: String {
        switch self {
        case .print: return RTKL10n.menuPrint.text
        }
    }
    
    /// The command's standard icon.
    var icon: Image {
        switch self {
        case .print: return .richTextMenuPrint
        }
    }
}

public extension Collection where Element == RichTextCommand {

    /// All available rich text actions.
    static var all: [RichTextCommand] { Element.allCases }
}
