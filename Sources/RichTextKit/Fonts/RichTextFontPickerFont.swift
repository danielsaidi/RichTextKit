//
//  RichTextFontPickerFont.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

/**
 This struct is used by the various font pickers.

 Instead of referring to actual fonts, this struct refers to
 fonts by name, to simplify view binding in e.g. the pickers.

 You can use ``RichTextFontPickerFont/all`` to get all fonts,
 then rearrange the fonts if needed.

 Some system fonts are special when being listed in a picker
 or displayed elsewhere. One such example is `San Francisco`,
 which must have its name adjusted in order to be presented.

 To change the display name of a system font, simply set the
 ``RichTextFontPickerFont/standardSystemFontDisplayName`` to
 another value.

 To change how a font is detected by the system, just change
 ``RichTextFontPickerFont/systemFontNamePrefix`` to a custom
 value, which will differ for each platform.
 */
public struct RichTextFontPickerFont: Identifiable, Equatable {

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

public extension RichTextFontPickerFont {

    /**
     Get all available system fonts.
     */
    static var all: [RichTextFontPickerFont] {
        let all = RichTextFontPickerFont.systemFonts
        let systemFont = RichTextFontPickerFont(fontName: "")
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

public extension RichTextFontPickerFont {
    
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

public extension Collection where Element == RichTextFontPickerFont {

    /**
     Get all available system fonts.
     */
    static var all: [RichTextFontPickerFont] {
        RichTextFontPickerFont.all
    }

    /**
     Move a certain font topmost in the list.

     This function can be used to highlight the current font
     in a picker, by moving it first.
     */
    func moveTopmost(_ topmost: String) -> [RichTextFontPickerFont] {
        let topmost = topmost.trimmingCharacters(in: .whitespaces)
        let exists = contains { $0.fontName.lowercased() == topmost.lowercased() }
        guard exists else { return Array(self) }
        var filtered = filter { $0.fontName.lowercased() != topmost.lowercased() }
        let new = RichTextFontPickerFont(fontName: topmost)
        filtered.insert(new, at: 0)
        return filtered
    }
}


// MARK: - System Fonts

private extension RichTextFontPickerFont {
    
    /**
     Get all available font picker fonts.
     */
    static var systemFonts: [RichTextFontPickerFont] {
        #if canImport(AppKit)
        return NSFontManager.shared
            .availableFontFamilies
            .map {
                RichTextFontPickerFont(fontName: $0)
            }
        #endif

        #if canImport(UIKit)
        return UIFont.familyNames
            .map {
                RichTextFontPickerFont(fontName: $0)
            }
        #endif
    }
}
