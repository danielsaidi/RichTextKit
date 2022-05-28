//
//  RichTextTrait.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum represents various rich text traits, such as bold,
 italic and underlined.

 This enum aims to simplify working with traits, by creating
 a single way to toggle certaint traits on and off, although
 they can then be handled differently within the library.
 */
public enum RichTextTrait: CaseIterable {

    /// Bold text.
    case bold

    /// Italic text.
    case italic

    /// Underlined text.
    case underlined
}

public extension RichTextTrait {

    /**
     The standard icon to use for the trait.
     */
    var icon: Image {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underlined: return .underline
        }
    }
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
