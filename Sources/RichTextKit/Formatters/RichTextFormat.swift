//
//  RichTextFormat.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-16.
//  Copyright © 2023 James Bradley. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import Combine
import SwiftUI

/**
 This formatter is used to format text in a ``RichTextView`` by
 specified font styling and a trigger character.
 */

open class RichTextFormat: NSObject {

    // MARK: - Initialization

    /**
     Create a rich text coordinator.

     - Parameters:
     
     */
    public init(
        font: UIFont = UIFont.systemFont(ofSize: 16.0),
        isBold: Bool = false,
        isItalic: Bool = false,
        isUnderlined: Bool = false,
        foregroundColor: UIColor = UIColor.black,
        backgroundColor: UIColor = UIColor.clear
    ) {
        self.font = font
        self.isBold = isBold
        self.isItalic = isItalic
        self.isUnderlined = isUnderlined
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        super.init()
    }


    // MARK: - Internal Properties

    /**
     The font style to apply to characters following a trigger character.
     */
    internal var font: UIFont
    
    /**
     The font style to apply to characters following a trigger character.
    */
    internal var isBold: Bool
    
    /**
     The font style to apply to characters following a trigger character.
    */
    internal var isItalic: Bool
    
    /**
     The font style to apply to characters following a trigger character.
    */
    internal var isUnderlined: Bool
    
    /**
     The font style to apply to characters following a trigger character.
    */
    internal var foregroundColor: ColorRepresentable
    
    /**
     The font style to apply to characters following a trigger character.
    */
    internal var backgroundColor: ColorRepresentable


    #if canImport(UIKit)


    #endif


    #if canImport(AppKit)

    #endif
}
#endif
