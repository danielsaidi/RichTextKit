//
//  CFGloat+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import CoreGraphics

/**
 This protocol can be implemented by any type that should be
 able to provide the standard rich text font size.

 This protocol is implemented by native types like `CGFloat`,
 `Double`, as well as library types like ``RichTextContext``,
 ``RichTextEditor`` and ``RichTextView``. All these types can
 use the ``StandardFontSizeProvider/standardRichTextFontSize``
 property to set the standard rich text font size.
 */
public protocol StandardFontSizeProvider {}

extension CGFloat: StandardFontSizeProvider {}

extension Double: StandardFontSizeProvider {}

extension RichTextContext: StandardFontSizeProvider {}

#if iOS || macOS || os(tvOS)
extension RichTextEditor: StandardFontSizeProvider {}

extension RichTextView: StandardFontSizeProvider {}
#endif

public extension StandardFontSizeProvider {

    /**
     The standard font size to use for rich text.

     You can change this value to affect all types that make
     use of this value.
     */
    static var standardRichTextFontSize: CGFloat {
        get { StandardFontSizeProviderStorage.standardRichTextFontSize }
    }
}

private class StandardFontSizeProviderStorage {

    static let standardRichTextFontSize: CGFloat = 16
}
