//
//  RichTextFormatter.swift
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

open class RichTextFormatter: NSObject {

    // MARK: - Initialization

    /**
     Create a rich text coordinator.

     - Parameters:
       - trigger: The character to signal format application.
       - format: The format to apply to the text.
       - options: .
     */
    public init(
        trigger: Character,
        format: RichTextFormat = RichTextFormat(),
        options: [String]
    ) {
        self.trigger = trigger
        self.format = format
        self.options = options
        super.init()
    }


    // MARK: - Internal Properties

    /**
     The character that activates the formatted style.
     */
    internal var trigger: Character

    /**
     The font style to apply to characters following a trigger character.
     */
    internal var format: RichTextFormat
    
    /**
     The options to present for selection upon formatting.
     */
    internal var options: [String]


    #if canImport(UIKit)


    #endif


    #if canImport(AppKit)

    #endif
}
#endif
