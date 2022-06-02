//
//  FontRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support.
 */
public typealias FontRepresentable = UIFont
#endif

#if canImport(AppKit)
import AppKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support. 
 */
public typealias FontRepresentable = NSFont
#endif

public extension FontRepresentable {

    /**
     The standard font to use for rich text.

     You can change this value to affect all types that make
     use of the value.
     */
    static var standardRichTextFont = systemFont(ofSize: .standardRichTextFontSize)
}
