//
//  String+Characters.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension String.Element {

    /// An `\r` carriage return string element.
    static var carriageReturn: String.Element { "\r" }

    /// An `\n` newline string element.
    static var newLine: String.Element { "\n" }

    /// A `\t` tab string element.
    static var tab: String.Element { "\t" }

    /// A ` ` space string element.
    static var space: String.Element { " " }
    
    /// If the string element is a new line separator.
    var isNewLineSeparator: Bool {
        self == .newLine || self == .carriageReturn
    }
}

public extension String {

    /// An `\r` carriage return string.
    static let carriageReturn = String(.carriageReturn)

    /// An `\n` newline string.
    static let newLine = String(.newLine)

    /// A `\t` tab string.
    static let tab = String(.tab)

    /// A ` ` space string.
    static let space = String(.space)
}
