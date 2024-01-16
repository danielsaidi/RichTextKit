//
//  RichTextStyle.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This enum represents various rich text styles, such as bold,
 italic and underlined.

 This enum aims to simplify working with styles, by creating
 a single way to toggle certain traits and attributes on and
 off, although they may be handled differently by the system.
 */
public enum RichTextStyle: String, CaseIterable, Identifiable {

    case bold
    case italic
    case underlined
    case strikethrough
}

public extension RichTextStyle {

    /// All available rich text styles.
    static var all: [Self] { allCases }
}

public extension Collection where Element == RichTextStyle {

    /// All available rich text styles.
    static var all: [RichTextStyle] { RichTextStyle.allCases }
}

public extension RichTextStyle {

    var id: String { rawValue }

    /**
     The standard icon to use for the trait.
     */
    var icon: Image {
        switch self {
        case .bold: .richTextStyleBold
        case .italic: .richTextStyleItalic
        case .strikethrough: .richTextStyleStrikethrough
        case .underlined: .richTextStyleUnderline
        }
    }
    
    /// The localized style title.
    var title: String {
        titleKey.text
    }
    
    /// The localized style title key.
    var titleKey: RTKL10n {
        switch self {
        case .bold: .styleBold
        case .italic: .styleItalic
        case .underlined: .styleUnderlined
        case .strikethrough: .styleStrikethrough
        }
    }

    /**
     Get the rich text styles that are enabled in a provided
     set of traits and attributes.

     - Parameters:
       - traits: The symbolic traits to inspect.
       - attributes: The rich text attributes to inspect.
     */
    static func styles(
        in traits: FontTraitsRepresentable?,
        attributes: RichTextAttributes?
    ) -> [RichTextStyle] {
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes?.isStrikethrough == true { styles.append(.strikethrough) }
        if attributes?.isUnderlined == true { styles.append(.underlined) }
        return styles
    }
}

public extension Collection where Element == RichTextStyle {

    /**
     Whether or not the collection contains a certain style.

     - Parameters:
       - style: The style to look for.
     */
    func hasStyle(_ style: RichTextStyle) -> Bool {
        contains(style)
    }
}

#if canImport(UIKit)
public extension RichTextStyle {

    /// The symbolic font traits for the style, if any.
    var symbolicTraits: UIFontDescriptor.SymbolicTraits? {
        switch self {
        case .bold: .traitBold
        case .italic: .traitItalic
        case .strikethrough: nil
        case .underlined: nil
        }
    }
}
#endif

#if macOS
public extension RichTextStyle {

    /// The symbolic font traits for the trait, if any.
    var symbolicTraits: NSFontDescriptor.SymbolicTraits? {
        switch self {
        case .bold: .bold
        case .italic: .italic
        case .strikethrough: nil
        case .underlined: nil
        }
    }
}
#endif
