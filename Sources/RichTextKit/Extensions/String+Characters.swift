//
//  String+Characters.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

extension String.Element {

    /**
     Get the string element for a `\r` carriage return.
     */
    static var carriageReturn: String.Element { "\r" }

    /**
     Get the string element for a `\n` newline.
     */
    static var newLine: String.Element { "\n" }

    /**
     Get the string element for a `\t` tab.
     */
    static var tab: String.Element { "\t" }
}

extension String {
    
    /**
     Get the string for a `\r` carriage return.
     */
    static let carriageReturn = String(.carriageReturn)

    /**
     Get the string for a `\n` newline.
     */
    static let newLine = String(.newLine)

    /**
     Get the string for a `\t` tab.
     */
    static let tab = String(.tab)
}
