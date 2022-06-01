//
//  Character+Newline.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

extension Character {

    /**
     Get whether or not the character is a newline separator.
     */
    var isNewLineSeparator: Bool {
        self == .newLine || self == .carriageReturn
    }
}
