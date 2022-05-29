//
//  String+Characters.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

extension String.Element {
    
    static var carriageReturn: String.Element { "\r" }
    static var newLine: String.Element { "\n" }
    static var tab: String.Element { "\t" }
}

extension String {
    
    static let carriageReturn = String(.carriageReturn)
    static let newLine = String(.newLine)
    static let tab = String(.tab)
}
