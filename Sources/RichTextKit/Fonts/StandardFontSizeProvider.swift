//
//  CFGloat+RichText.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import CoreGraphics

/**
 This protocol can be implemented by any type that should be
 able to provide the standard rich text font size.

 The protocol is implemented by `CGFloat` and can be used by
 any custom types that need to be get and set this font size.
 */
public protocol StandardFontSizeProvider {}

extension CGFloat: StandardFontSizeProvider {}

public extension StandardFontSizeProvider {

    /**
     The standard font size to use for rich text.

     You can change this value to affect all types that make
     use of this value.
     */
    static var standardRichTextFontSize: CGFloat {
        get { StandardFontSizeProviderStorage.standardRichTextFontSize }
        set { StandardFontSizeProviderStorage.standardRichTextFontSize = newValue }
    }
}

private class StandardFontSizeProviderStorage {

    static var standardRichTextFontSize: CGFloat = 16
}
