//
//  FontPickerFont.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

/**
 This font struct is used by the various font pickers.

 Instead of referring to certain fonts, the struct refers to
 fonts by name, to simplify view binding in e.g. the pickers.
 You can use `FontPickerFont.all` to get all fonts, then use
 collection extensions like `moveFirst(...)` to manage order.

 Some system fonts are special when it comes to being listed
 in a picker or displayed in other ways. One such example is
 `San Francisco`, which must have its name replaced in order
 to be properly presented.

 To change the display name of the system font, just set the
 ``FontPickerFont/standardSystemFontDisplayName`` to another
 value. To customize how the system font for a platform will
 be detected, just set ``FontPickerFont/systemFontNamePrefix``
 to another value.
 */
public struct FontPickerFont: Identifiable, Equatable {
    
    public init(fontName: String) {
        let fontName = fontName.capitalized
        self.fontName = fontName
        self.fontDisplayName = ""
        self.fontDisplayName = displayName
    }

    public let fontName: String
    public private(set) var fontDisplayName: String

    /**
     Get the unique font id.
     */
    public var id: String {
        fontName.lowercased()
    }
}


// MARK: - Static Properties

public extension FontPickerFont {

    /**
     Get all available system fonts.
     */
    static var all: [FontPickerFont] {
        let all = FontPickerFont.systemFonts
        let systemFont = FontPickerFont(fontName: "")
        var sorted = all.sorted { $0.fontDisplayName < $1.fontDisplayName }
        sorted.insert(systemFont, at: 0)
        return sorted
    }

    /**
     The display name for the standard system font, which is
     used if the font name is empty.
     */
    static var standardSystemFontDisplayName: String {
        #if os(macOS)
        return "Standard"
        #else
        return "San Francisco"
        #endif
    }

    /**
     The font name prefix for the standard system font. This
     is used if the font name is empty.
     */
    static var systemFontNamePrefix: String {
        #if os(macOS)
        return ".AppleSystemUIFont"
        #else
        return ".SFUI"
        #endif
    }
}


// MARK: - Public Properties

public extension FontPickerFont {
    
    /**
     Get the display name for the font.

     This may need to account for the cases where the font's
     name may be system-specific and non-descriptive.
     */
    var displayName: String {
        let isSystemFont = isStandardSystemFont
        let systemName = Self.standardSystemFontDisplayName
        return isSystemFont ? systemName : fontName
    }
    
    /**
     Check whether or not a certain font name represents the
     standard system font (e.g. San Francisco for iOS).
     */
    var isStandardSystemFont: Bool {
        let name = fontName.trimmingCharacters(in: .whitespaces)
        if name.isEmpty { return true }
        let systemPrefix = Self.systemFontNamePrefix
        return name.uppercased().hasPrefix(systemPrefix)
    }
}


// MARK: - Collection Extensions

public extension Collection where Element == FontPickerFont {

    /**
     Get all available system fonts.
     */
    static var all: [FontPickerFont] {
        FontPickerFont.all
    }

    /**
     Move a certain font topmost in the list.

     This function can be used to highlight the current font
     in a picker, by moving it first.
     */
    func moveTopmost(_ topmost: String) -> [FontPickerFont] {
        let topmost = topmost.trimmingCharacters(in: .whitespaces)
        let exists = contains { $0.fontName.lowercased() == topmost.lowercased() }
        guard exists else { return Array(self) }
        var filtered = filter { $0.fontName.lowercased() != topmost.lowercased() }
        let new = FontPickerFont(fontName: topmost)
        filtered.insert(new, at: 0)
        return filtered
    }
}


// MARK: - System Fonts

private extension FontPickerFont {
    
    /**
     Get all available font picker fonts.
     */
    static var systemFonts: [FontPickerFont] {
        #if canImport(AppKit)
        return NSFontManager.shared
            .availableFontFamilies
            .map {
                FontPickerFont(fontName: $0)
            }
        #endif

        #if canImport(UIKit)
        return UIFont.familyNames
            .map {
                FontPickerFont(fontName: $0)
            }
        #endif
    }
}
