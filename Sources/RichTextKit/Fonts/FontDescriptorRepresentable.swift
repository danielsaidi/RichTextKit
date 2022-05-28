//
//  FontDescriptorRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if canImport(AppKit)
import AppKit

/**
 This typealias bridges platform-specific font descriptors.

 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontDescriptorRepresentable = NSFontDescriptor

public extension FontDescriptorRepresentable {

    func byTogglingStyle(_ style: RichTextStyle) -> FontDescriptorRepresentable {
        guard let traits = style.symbolicTraits else { return self }
        if symbolicTraits.contains(traits) {
            return withSymbolicTraits(symbolicTraits.subtracting(traits))
        } else {
            return withSymbolicTraits(symbolicTraits.union(traits))
        }
    }
}
#endif

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific font descriptors.

 The typealias also defines additional functionality as type
 extensions for the platform-specific types.
 */
public typealias FontDescriptorRepresentable = UIFontDescriptor

public extension FontDescriptorRepresentable {
/**
 Get a new font descriptor by toggling a certain text style.
 */
func byTogglingStyle(_ style: RichTextStyle) -> FontDescriptorRepresentable {
    guard let traits = style.symbolicTraits else { return self }
    if symbolicTraits.contains(traits) {
        return withSymbolicTraits(symbolicTraits.subtracting(traits)) ?? self
    } else {
        return withSymbolicTraits(symbolicTraits.union(traits)) ?? self
    }
}
}
#endif
