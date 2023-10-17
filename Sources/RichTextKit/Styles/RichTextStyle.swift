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
        case .bold: return .richTextStyleBold
        case .italic: return .richTextStyleItalic
        case .strikethrough: return .richTextStyleStrikethrough
        case .underlined: return .richTextStyleUnderline
        }
    }

    /// The styles title.
    var title: String {
        switch self {
        case .bold: return RTKL10n.styleBold.text
        case .italic: return RTKL10n.styleItalic.text
        case .underlined: return RTKL10n.styleUnderlined.text
        case .strikethrough: return RTKL10n.styleStrikethrough.text
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
        case .bold: return .traitBold
        case .italic: return .traitItalic
        case .strikethrough: return nil
        case .underlined: return nil
        }
    }
}
#endif

#if os(macOS)
public extension RichTextStyle {

    /// The symbolic font traits for the trait, if any.
    var symbolicTraits: NSFontDescriptor.SymbolicTraits? {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .strikethrough: return nil
        case .underlined: return nil
        }
    }
}
#endif
