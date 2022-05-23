//
//  RichTextTrait.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum represents various traits that rich text can have.
 */
public enum RichTextTrait {

    /// Bold text
    case bold

    /// Italic text
    case italic

    /// Underlined text
    case underlined
}

#if canImport(UIKit)
public extension RichTextTrait {

    /**
     The symbolic font traits for the trait, if any.
     */
    var symbolicTraits: UIFontDescriptor.SymbolicTraits? {
        switch self {
        case .bold: return .traitBold
        case .italic: return .traitItalic
        case .underlined: return nil
        }
    }
}
#endif

#if os(macOS)
public extension RichTextTrait {

    /**
     The symbolic font traits for the trait, if any.
     */
    var symbolicTraits: NSFontDescriptor.SymbolicTraits? {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underlined: return nil
        }
    }
}
#endif
